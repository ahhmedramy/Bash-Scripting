version: '3.8'

services:
  wazuh.manager:
    image: wazuh/wazuh:4.7.2
    hostname: wazuh.manager
    ports:
      - "1514:1514/udp"
      - "1515:1515"
      - "55000:55000"
    volumes:
      - wazuh-data:/var/ossec/data

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.10.2
    environment:
      - discovery.type=single-node
      - ES_JAVA_OPTS=-Xms1g -Xmx1g
    ulimits:
      memlock:
        soft: -1
        hard: -1
    mem_limit: 2g
    volumes:
      - esdata:/usr/share/elasticsearch/data

  kibana:
    image: docker.elastic.co/kibana/kibana:7.10.2
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200

  suricata:
    image: jasonish/suricata:latest
    command: -i eth0
    network_mode: host
    cap_add:
      - NET_ADMIN
      - NET_RAW
    volumes:
      - ./suricata:/etc/suricata

  misp:
    image: harvarditsecurity/misp
    ports:
      - "8443:443"
      - "8080:80"
    environment:
      - POSTGRES_PASSWORD=misp123
    restart: unless-stopped

  cyberchef:
    image: mpepping/cyberchef
    ports:
      - "8000:8000"

volumes:
  wazuh-data:
  esdata:
