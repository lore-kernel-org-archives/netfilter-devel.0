Return-Path: <SRS0=UFFK=AD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NUMERIC_HTTP_ADDR,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1,
	WEIRD_PORT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D283CC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 15:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A146120732
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Jun 2020 15:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgFVPT7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 11:19:59 -0400
Received: from mail.thelounge.net ([91.118.73.15]:55321 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729290AbgFVPT5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 11:19:57 -0400
Received: from srv-rhsoft.rhsoft.net (rh.vpn.thelounge.net [10.10.10.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: h.reindl@thelounge.net)
        by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 49rCkx410dzXST;
        Mon, 22 Jun 2020 17:19:53 +0200 (CEST)
Subject: Re: iptables user space performance benchmarks published
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200619141157.GU23632@orbyte.nwl.cc>
 <20200622124207.GA25671@salvia>
 <faf06553-c894-e34c-264e-c0265e3ee071@thelounge.net>
 <20200622140450.GZ23632@orbyte.nwl.cc>
 <1a32ffd2-b3a2-cf60-9928-3baa58f7d9ef@thelounge.net>
 <20200622145410.GB23632@orbyte.nwl.cc>
From:   Reindl Harald <h.reindl@thelounge.net>
Organization: the lounge interactive design
Message-ID: <eef37fef-0e6c-b948-7195-76ce2e2be93b@thelounge.net>
Date:   Mon, 22 Jun 2020 17:19:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200622145410.GB23632@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



Am 22.06.20 um 16:54 schrieb Phil Sutter:
> On Mon, Jun 22, 2020 at 04:11:06PM +0200, Reindl Harald wrote:
>> Am 22.06.20 um 16:04 schrieb Phil Sutter:
>>>> i gave it one try and used "iptables-nft-restore" and "ip6tables-nft",
>>>> after reboot nothing worked at all
>>>
>>> Not good. Did you find out *why* nothing worked anymore? Would you maybe
>>> care to share your script and ruleset with us?
>>
>> i could share it offlist, it's a bunch of stuff including a managament
>> interface written in bash and is designed for a /24 1:1 NETMAP
> 
> Yes, please share off-list. I'll see if I can reproduce the problem.
> 
>> basicaly it already has a config-switch to enforce iptables-nft
>>
>> FILE                    TOTAL  STRIPPED  SIZE
>> tui.sh                  1653   1413      80K
>> firewall.sh             984    738       57K
>> shared.inc.sh           578    407       28K
>> custom.inc.sh           355    112       13K
>> config.inc.sh           193    113       6.2K
>> update-blocked-feed.sh  68     32        4.1K
> 
> Let's hope I don't have to read all of that. /o\

to see the testing implemented please scroll at the bottom :-)

that whole stuff lives in a demo-setup at home reacting slightly
different when $HOSTNAME is "firewall.vmware.local"

surely, you can have the scripts alone but it's likely easier to get the
ESXi started somehow and have a fully working network reflecting
produtkin just with different LAN/WAN ranges

-------------------------------

in the config.inc.sh the line "ENABLE_IPTABLES_NFT=1" would switch the
backend and before reboot /etc/systemd/system/network-up.service needs
to be adjusted to also use iptables-nft for restore

-------------------------------

the ESXi nested in Vmware Workstation hosts 4 VMS

* firewall
* test (two ips on the wan interface)
* client (full /24 , listening on tcp 1-65535)
* buildsever to compile packages

on the vm "test" there is a script checking if the ruleset works as
expected, nat, wireguard and so on

see output of the "make me happy testing" interacting between fuirewall,
test and client

-------------------------------

what i can offer you is the whole folder after set "letmein" as root
password everywhere over some private channel and finally replace all my
ssh/wiregaurd-keys *after* that

so you can have a fully working setup and in case you hand over a ssh
public key i add it to allowed-keys before dump the whole beast

-------------------------------

[root@srv-rhsoft:~]$ ls /vmware/esx/
insgesamt 4,9G
-rw------- 1 vmware vmware 265K 2020-06-22 10:27 esx1.nvram
-rw------- 1 vmware vmware 4,9G 2020-06-22 17:07 esx1-1.vmdk
-rw------- 1 vmware vmware   67 2020-06-20 19:32 esx1.vmsd
-rwx------ 1 vmware vmware 4,5K 2020-06-21 17:07 esx1.vmx
-rw------- 1 vmware vmware  259 2020-06-20 19:32 esx1.vmxf

-------------------------------

not sure how well that goes with ESXi7 and how to convert the vmware
vmdk properly, that's you part :-)

https://fabianlee.org/2018/09/19/kvm-deploying-a-nested-version-of-vmware-esxi-6-7-inside-kvm/

-------------------------------


[root@firewall:~]$ stresstest.sh
Starting netserver with host 'IN(6)ADDR_ANY' port '12865' and family
AF_UNSPEC
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost ()
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.00    8668.17
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost ()
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.00    8795.55
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost ()
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.00    8873.98
TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to localhost ()
port 0 AF_INET
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

131072  16384  16384    10.00    8414.01
hping in flood mode, no replies will be shown
hping in flood mode, no replies will be shown
hping in flood mode, no replies will be shown
hping in flood mode, no replies will be shown

--- 172.17.0.x hping statistic ---
136100 packets transmitted, 0 packets received, 100% packet loss

--- 172.17.0.x hping statistic ---
round-trip min/avg/max = 0.0/0.0/0.0 ms
HPING 172.17.0.x (eth0 172.17.0.x): S set, 40 headers + 0 data bytes
HPING 172.17.0.x (eth0 172.17.0.x): SPUXY set, 40 headers + 0 data bytes
HPING 172.17.0.5 (eth0 172.17.0.5): S set, 40 headers + 0 data bytes
135812 packets transmitted, 0 packets received, 100% packet loss
round-trip min/avg/max = 0.0/0.0/0.0 ms

--- 172.17.0.5 hping statistic ---
136939 packets transmitted, 0 packets received, 100% packet loss
round-trip min/avg/max = 0.0/0.0/0.0 ms
HPING 172.17.0.6 (eth0 172.17.0.6): S set, 40 headers + 0 data bytes

--- 172.17.0.6 hping statistic ---
137024 packets transmitted, 0 packets received, 100% packet loss
round-trip min/avg/max = 0.0/0.0/0.0 ms
---------------------------------------------------------
172.17.0.1:

TCP 8000: 0 OK
---------------------------------------------------------
172.17.0.16:

UDP 53: 1 OK
UDP 853: 1 OK
TCP 53: 1 OK
TCP 10022: 1 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 3389: 0 OK
TCP 5900: 0 OK
---------------------------------------------------------
172.17.0.2:

TCP 445: 1 OK
TCP 3306: 1 OK
TCP 3389: 1 OK
TCP 5900: 1 OK
---------------------------------------------------------
172.17.0.3:

TCP 10022: 1 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
---------------------------------------------------------
172.17.0.4:

UDP 53: 0 OK
TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
---------------------------------------------------------
172.17.0.5:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.6:

UDP 53: 0 OK
UDP 67: 0 OK
UDP 68: 0 OK
TCP 21: 1 OK
TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 143: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 8080: 0 OK
TCP 8443: 0 OK
---------------------------------------------------------
172.17.0.8:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.9:

TCP 80: 1 OK
TCP 443: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.10:

TCP 80: 1 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.11:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.15:

UDP 53: 0 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 24: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 2000: 0 OK
TCP 3306: 0 OK
TCP 465: 1 OK
TCP 587: 1 OK
TCP 588: 1 OK
TCP 110: 1 OK
TCP 143: 1 OK
TCP 993: 1 OK
TCP 995: 1 OK
TCP 10022: 1 OK
---------------------------------------------------------
172.17.0.17:

TCP 21: 1 OK
TCP 80: 1 OK
TCP 443: 1 OK
TCP 465: 1 OK
TCP 587: 1 OK
TCP 110: 1 OK
TCP 143: 1 OK
TCP 993: 1 OK
TCP 995: 1 OK
TCP 10022: 1 OK
TCP 22: 0 OK
TCP 23: 0 OK
TCP 24: 0 OK
TCP 25: 0 OK
TCP 445: 0 OK
TCP 2000: 0 OK
TCP 3306: 0 OK
TCP 3307: 0 OK
---------------------------------------------------------
172.17.0.19:

UDP 53: 0 OK
UDP 1053: 0 OK
TCP 25: 1 OK
TCP 10022: 1 OK
TCP 22: 0 OK
TCP 53: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10025: 0 OK
---------------------------------------------------------
172.17.0.20:

TCP 25: 1 OK
TCP 10022: 0 OK
TCP 22: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
---------------------------------------------------------
172.17.0.21:

TCP 25: 1 OK
TCP 10022: 0 OK
TCP 22: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
---------------------------------------------------------
172.17.0.30:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 873: 0 OK
TCP 5222: 0 OK
TCP 5269: 0 OK
---------------------------------------------------------
172.17.0.32:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
---------------------------------------------------------
172.17.0.34:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.35:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.38:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 3306: 0 OK
TCP 445: 0 OK
---------------------------------------------------------
172.17.0.99:

TCP 80: 1 OK
TCP 443: 1 OK
TCP 10022: 1 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 23: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 445: 0 OK
TCP 465: 0 OK
TCP 587: 0 OK
TCP 110: 0 OK
TCP 143: 0 OK
TCP 993: 0 OK
TCP 995: 0 OK
TCP 3306: 0 OK
TCP 3307: 0 OK
---------------------------------------------------------
172.17.0.115:

UDP 5353: 0 OK
TCP 21: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 548: 0 OK
TCP 3306: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.116:

UDP 111: 0 OK
UDP 139: 0 OK
UDP 2049: 0 OK
TCP 111: 0 OK
TCP 139: 0 OK
TCP 445: 0 OK
TCP 2049: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
172.17.0.132:

UDP 53: 0 OK
UDP 69: 0 OK
UDP 88: 0 OK
UDP 111: 0 OK
UDP 135: 0 OK
UDP 514: 0 OK
UDP 902: 0 OK
UDP 930: 0 OK
UDP 5355: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 80: 0 OK
TCP 88: 0 OK
TCP 111: 0 OK
TCP 135: 0 OK
TCP 389: 0 OK
TCP 443: 0 OK
TCP 514: 0 OK
TCP 587: 0 OK
TCP 636: 0 OK
TCP 1514: 0 OK
TCP 2012: 0 OK
TCP 2014: 0 OK
TCP 2015: 0 OK
TCP 2020: 0 OK
TCP 5090: 0 OK
TCP 5432: 0 OK
TCP 5443: 0 OK
TCP 5480: 0 OK
TCP 7080: 0 OK
TCP 7081: 0 OK
TCP 7444: 0 OK
TCP 8006: 0 OK
TCP 8085: 0 OK
TCP 8089: 0 OK
TCP 8190: 0 OK
TCP 8191: 0 OK
TCP 8200: 0 OK
TCP 8201: 0 OK
TCP 8300: 0 OK
TCP 8301: 0 OK
TCP 8900: 0 OK
TCP 9090: 0 OK
TCP 9443: 0 OK
TCP 10080: 0 OK
TCP 11711: 0 OK
TCP 11712: 0 OK
TCP 12080: 0 OK
TCP 12346: 0 OK
TCP 12721: 0 OK
TCP 13080: 0 OK
TCP 15005: 0 OK
TCP 15007: 0 OK
TCP 16666: 0 OK
TCP 18090: 0 OK
TCP 18091: 0 OK
TCP 22000: 0 OK
TCP 22100: 0 OK
TCP 39950: 0 OK
---------------------------------------------------------
172.17.0.100:

UDP 427: 0 OK
UDP 443: 0 OK
UDP 549: 0 OK
UDP 902: 0 OK
TCP 22: 0 OK
TCP 80: 0 OK
TCP 427: 0 OK
TCP 443: 0 OK
TCP 549: 0 OK
TCP 902: 0 OK
---------------------------------------------------------
172.17.0.128:

UDP 427: 0 OK
UDP 443: 0 OK
UDP 549: 0 OK
UDP 902: 0 OK
TCP 22: 0 OK
TCP 80: 0 OK
TCP 427: 0 OK
TCP 443: 0 OK
TCP 549: 0 OK
TCP 902: 0 OK
---------------------------------------------------------
172.17.0.215:

UDP 53: 0 OK
UDP 5353: 0 OK
TCP 22: 0 OK
TCP 25: 0 OK
TCP 53: 0 OK
TCP 80: 0 OK
TCP 443: 0 OK
TCP 445: 0 OK
TCP 3306: 0 OK
TCP 5900: 0 OK
TCP 10022: 0 OK
---------------------------------------------------------
OK: 323, TCP-OPEN: 60, UDP-OPEN: 2, RUNTIME: 42

---------------------------------------------------------
PORTSCAN-TRIGGER:

CALL HONEYPOT: http://172.17.0.98:445: OK: (Status: 1)
CALL ALLOWED: http://172.17.0.6:80: OK: (Status: 1)
CALL TRIGGER: http://172.17.0.6:445: OK: (Status: 0)
CALL CHECK: http://172.17.0.6:80: OK: (Status: 0)
CALL CHECK: http://172.17.0.6:80: OK: (Status: 0)
SLEEP 12 seconds
OK: (http://172.17.0.6:80, Status: 1)
---------------------------------------------------------

---------------------------------------------------------
CONNLIMIT:

CALL ALLOWED: http://172.17.0.6:80: OK: (Status: 1)
CALL 500 TIMES IN BACKGROUND: http://172.17.0.6:80
CALL: http://172.17.0.6:80: OK: (Status: 0)
---------------------------------------------------------

---------------------------------------------------------
VPN:

UDP 172.17.0.6:53: 0 OK
UDP 172.16.0.6:53: 1 OK
TCP 172.17.0.6:445: 0 OK
TCP 172.16.0.6:445: 1 OK

WIREGUARD:
Mon Jun 22 17:13:50 CEST 2020
Mon Jun 22 17:14:06 CEST 2020
 * 200 Mbits/sec
 * 203 Mbits/sec
Mon Jun 22 17:14:22 CEST 2020

NAT:
Mon Jun 22 17:14:22 CEST 2020
Mon Jun 22 17:14:38 CEST 2020
 * 661 Mbits/sec
 * 1.20 Gbits/sec
Mon Jun 22 17:14:54 CEST 2020

LAN:
Mon Jun 22 17:14:54 CEST 2020
Mon Jun 22 17:15:10 CEST 2020
 * 3.50 Gbits/sec
 * 4.46 Gbits/sec
Mon Jun 22 17:15:26 CEST 2020
