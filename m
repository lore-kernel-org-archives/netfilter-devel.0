From: Taehee Yoo <ap420073@gmail.com>
Subject: [PATCH V4 0/5] netfilter: nf_nat_snmp_basic: use ASN.1 decoder
Date: Mon, 25 Dec 2017 23:58:49 +0900
Message-ID: <20171225145849.3773-1-ap420073@gmail.com>
Cc: ap420073@gmail.com
To: pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:36111 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752288AbdLYO65 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Dec 2017 09:58:57 -0500
Received: by mail-pl0-f67.google.com with SMTP id b12so16746696plm.3
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Dec 2017 06:58:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The goal of this patch set are to use the ASN.1 decoder library
to parse SNMP ASN.1 payload.

This patch set are same as previous patch
"[PATCH V2]netfilter: nf_nat_snmp_basic: use asn1 decoder library".

My test environment are below.

#Network
Client <-------------> Netfilter FW <-------------> SNMP Server
192.168.3.2   192.168.3.1      192.168.4.1   192.168.4.2

#FW commands
   iptables -t raw -I PREROUTING -p udp -m multiport --dports 161,162 \
	-j CT --helper snmp
   echo 'file nf_nat_snmp_basic_main.c +p' > \
	/sys/kernel/debug/dynamic_debug/control

#SNMP Server commands
   sudo ip r a 192.168.3.2 via 192.168.4.1 dev enp2s0
#Client commands
   sudo ip r a 192.168.4.2 via 192.168.3.1 dev enp3s0

To test basic snmp test, I used snmpwalk command because it is easy to use
   snmpwalk -v <1 or 2c> -c public <ip address> OID
example)
   snmpwalk -v 2c -c public 192.168.4.2 .1.3.6.1.2.1.4.21

so that we can see this message from dmesg.
"snmp_helper: 192.168.3.2 to 192.168.4.1"

And, to test snmp trap test, I used snmptrap command.
   snmptrap -v 1 -c public 192.168.3.2 .1 192.168.4.2 0 0 0 .1 a \
	192.168.4.2
   snmptrap -v 2c -c public 192.168.3.2 .1 .1 .1 a 192.168.4.2

SNMPv1 trap includes two ip address in payload. so we can see below
message twice.
"snmp_helper: 192.168.4.2 to 192.168.3.1"

If you want to see asn1 decoder debug message, please use below command
echo 'file asn1_decoder.c +p' > /sys/kernel/debug/dynamic_debug/control


V4 :
 - rename nf_nat_snmp_basic.c to nf_nat_snmp_basic_main.c
 to fix compile error

V3 :
 - be separated by previous patch.

V2 :
 - Add missing nf_nat_snmp_basic.asn1 file

V1 :
 - Initial patch


Taehee Yoo (5):
  netfilter: nf_nat_snmp_basic: remove useless comment
  netfilter: nf_nat_snmp_basic: remove debug parameter
  netfilter: nf_nat_snmp_basic: replace ctinfo with dir.
  netfilter: nf_nat_snmp_basic: use nf_ct_helper_log
  netfilter: nf_nat_snmp_basic: use asn1 decoder library

 net/ipv4/netfilter/Kconfig                         |    1 +
 net/ipv4/netfilter/Makefile                        |    6 +
 net/ipv4/netfilter/nf_nat_snmp_basic.asn1          |  177 +++
 ...f_nat_snmp_basic.c => nf_nat_snmp_basic_main.c} | 1181 ++------------------
 4 files changed, 249 insertions(+), 1116 deletions(-)
 create mode 100644 net/ipv4/netfilter/nf_nat_snmp_basic.asn1
 rename net/ipv4/netfilter/{nf_nat_snmp_basic.c => nf_nat_snmp_basic_main.c} (15%)

-- 
2.9.3

