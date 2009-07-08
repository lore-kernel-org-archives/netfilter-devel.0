From: Amos Jeffries <squid3@treenet.co.nz>
Subject: TPROXY / DIVERT
Date: Wed, 08 Jul 2009 18:24:50 +1200
Message-ID: <4A543BB2.5080906@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:36789
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZGHGfe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:35:34 -0400
Received: from troja.treenetnz.com. (121-72-7-177.dsl.telstraclear.net [121.72.7.177])
	by treenet.co.nz (Postfix) with ESMTP id CCCC9205095
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2009 18:24:52 +1200 (NZST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

TPROXY is turning out alright for most of our users. The iptables and 
kernel changes seem to work perfectly. Thanks a lot guys.

We are just working our way through how it needs to fit into various 
other network toolchains and re-documenting.


Two netfilter relevant questions have arisen:

The old one: How long until IPv6 TPROXY support is available?


The new one: How to configure TPROXY on a bridge?

  Is anyone able to assist in providing a configuration change or a fix 
that would get this going?

  The info I have been given from the admin so far is this configuration 
sort of works but is extremely slow at best. I suspect packet loops 
somewhere, or maybe issues with related outbound streams which are not 
spoofed:

> ebtables -t broute -A BROUTING -i eth1 -p ipv4 --ip-proto tcp --ip-dport 80 -j redirect --redirect-target DROP
> ebtables -t broute -A BROUTING -i eth0 -p ipv4 --ip-proto tcp --ip-sport 80 -j redirect --redirect-target DROP 

>> iptables -t mangle -N DIVERT
>> iptables -t mangle -A DIVERT -j MARK --set-mark 1
>> iptables -t mangle -A DIVERT -j ACCEPT
>> iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
>> iptables -t mangle -A PREROUTING -i eth1 -p tcp --dport 80 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3129

>> echo 1 > /proc/sys/net/ipv4/ip_forward
>> ip rule add fwmark 1 lookup 100
>> ip route add local 0.0.0.0/0 dev lo table 100

>> cd /proc/sys/net/bridge/
>> for i in *
>> do
>>  echo 0 > $i
>> done
>> unset i 


 > Ok retested squid.  Here are the scenarios and results
 >
 > 1.  no ebtables--no entries in access.log  squid server is only acting
 > as a bridge.
 > 2.  with ebtables using ACCEPT for both source and destination--no
 > entries in access.log  squid server is only acting as a bridge.
 > 3.  with ebtables using ACCEPT for source and DROP for
 > destination--entries in access.log squid slow to respond to requests
 > 4. with ebtables using DROP for source and ACCEPT for destination--no
 > entries in access.log  squid server is only acting as a bridge.
 > 5. original setup with ebtables set to DROP for both source and
 > destination--entries in access.log squid slow to respond to requests
 > 6. with ebtables only for destination set to DROP and no entry for
 > source--no internet
 > 7. with ebtables only for source set to DROP and no entry for
 > destination--no entries in access.log  squid server is only acting as a
 > bridge.
 > 8. with ebtables only for destination set to ACCEPT and no entry for
 > source--no entries in access.log  squid server is only acting as a 
bridge.
 > 9. with ebtables only for source set to ACCEPT and no entry for
 > destination----no entries in access.log  squid server is only acting as
 > a bridge.
 >
 > According to testing the only way to get squid to work in bridge mode is
 > either using scenario #3 or # 5.
 >
 > *scenario #3:*
 >
 > ebtables -t broute -A BROUTING -i eth1 -p ipv4 --ip-proto tcp --ip-dport
 > 80 -j redirect --redirect-target DROP
 > ebtables -t broute -A BROUTING -i eth0 -p ipv4 --ip-proto tcp --ip-sport
 > 80 -j redirect --redirect-target ACCEPT
 >
 > *scenario #5:
 > *
 > ebtables -t broute -A BROUTING -i eth1 -p ipv4 --ip-proto tcp --ip-dport
 > 80 -j redirect --redirect-target DROP
 > ebtables -t broute -A BROUTING -i eth0 -p ipv4 --ip-proto tcp --ip-sport
 > 80 -j redirect --redirect-target DROP
 >
 > Tom



Cheers
Amos Jeffries
Squid Project
