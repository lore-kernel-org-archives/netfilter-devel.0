Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA4AEEB64D7
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 17:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjFURFc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 13:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjFURFb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 13:05:31 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 21 Jun 2023 10:05:29 PDT
Received: from picard.host.weltraumschlangen.de (picard.host.weltraumschlangen.de [IPv6:2a03:4000:7:3bd::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543C7120;
        Wed, 21 Jun 2023 10:05:29 -0700 (PDT)
Received: from [IPV6:2003:cf:ef0a:9300:9e2b:6aaf:ea73:e9e4] (p200300cfef0a93009e2b6aafea73e9e4.dip0.t-ipconnect.de [IPv6:2003:cf:ef0a:9300:9e2b:6aaf:ea73:e9e4])
        by picard.host.weltraumschlangen.de (Postfix) with ESMTPSA id 566D060240;
        Wed, 21 Jun 2023 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weltraumschlangen.de;
        s=default; t=1687366004;
        bh=ypFq3Hy5Ug69KxlMuuzLAFHAdswop+HTm85KyFlpf0U=;
        h=Date:To:Cc:From:Subject:From;
        b=NFimPLeH4y0xL1umbSsYN0zrbNPYEu4Y4qUuHZHKEEGp0WDH52fzPvT/75PvIfSBZ
         NJJ7UN9lNZ81KB98yXEq0siRDr8by96KdOofIHpXoSpZ8Y1nM1bvAuKjyWjchR0HTT
         zDxdoWmYK3SOjYFdTXkQVmCkH1oRyv0topU3vpg/H76/PK8pyCnrakLPfpPKnKfDMD
         ZkbyNFA/pglADtYaAiFjsCoWQlVWmUTGLStpNvnti8q12+rGRhPDG+Ud/QX5G0oZui
         1xl7aWrNHKUiC+i3J1/Rd8q7hoLeCfSHqv/GNMMNQP3Fi+yI4172U4QplFFx2src2U
         Jtn3X/NMLbmkg==
Content-Type: multipart/mixed; boundary="------------IWmv06F5K0ydfM57bOh0gNny"
Message-ID: <d3c93e6a-f8a0-5c72-d044-dcec7d8d235c@weltraumschlangen.de>
Date:   Wed, 21 Jun 2023 18:46:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
To:     lvs-devel@vger.kernel.org
Content-Language: en-US
Cc:     netfilter-devel@vger.kernel.org
From:   Sven Bartscher <sven.bartscher@weltraumschlangen.de>
Subject: vs conntrack changes TCP ports mid-stream
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------IWmv06F5K0ydfM57bOh0gNny
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I'm forwarding the report from 
https://bugzilla.netfilter.org/show_bug.cgi?id=1669 here, since it was 
pointed out there, that this list would be more appropriate.

When using an ipvs service in combination with SNAT and a NOTRACK rule, 
specific circumstances can lead to TCP ports of packets being changed 
mid-stream, which results in successful connections that no data can be 
effectively sent over.

Consider the following example:

```
root@router:~# sysctl net.ipv4.vs.conntrack
net.ipv4.vs.conntrack = 1

root@router:~# iptables -t raw -L -n -v
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination
    24  1296 CT         tcp  --  enp1s0 *       0.0.0.0/0 
10.0.0.1             tcp dpt:1234 NOTRACK

root@router:~# iptables -t nat -L -n -v
Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination

Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination

Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination

Chain POSTROUTING (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination
     4   240 SNAT       all  --  *      *       10.0.0.0/24 
10.0.1.0/24          to:10.0.1.1

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source 
destination

root@router:~# ipvsadm -L -n
IP Virtual Server version 1.2.1 (size=4096)
Prot LocalAddress:Port Scheduler Flags
   -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
TCP  10.0.0.1:1234 rr
   -> 10.0.1.2:1234                Masq    1      0          0
   -> 10.0.1.3:1234                Masq    1      0          0
```

The reals servers are running

```
socat TCP4-LISTEN:1234,fork 'EXEC:sh -c 
echo${IFS}hello;read${IFS}r${IFS}L;sleep${IFS}1'
```

We dump the network traffic between the router and client on the ipvs 
router as follows:

```
root@router:~# tcpdump -pXXni enp1s0 icmp or tcp -w 
/tmp/ipvs_port_reuse.pcap
tcpdump: listening on enp1s0, link-type EN10MB (Ethernet), capture size 
262144 bytes
^C16 packets captured
16 packets received by filter
0 packets dropped by kernel
```

While the capture is running, we run the following commands on a client 
to trigger the buggy behavior:

```
root@debian:~# netcat -p 4321 -v 10.0.01 1234
Connection to 10.0.01 1234 port [tcp/*] succeeded!
hello
^C
root@debian:~# sleep 60
root@debian:~# netcat -p 4321 -v 10.0.01 1234
Connection to 10.0.01 1234 port [tcp/*] succeeded!
^C
root@debian:~#
```

We can see that on the first connection attempt we successfully receive 
a reply with payload from the server and then terminate the connection 
with Ctrl+C. Then we wait 60 seconds, which is necessary for the 
previous connection to move out of the TIME_WAIT state. Afterwards we 
open another connection, reusing the same src port as on the first 
connection and don't receive a reply from the server. The captured 
traffic shows, that after the three-way handshake for the second TCP 
connection, packets from the router to the clients use another server 
port than the one used for the initiation of the connection.

Regards
Sven
--------------IWmv06F5K0ydfM57bOh0gNny
Content-Type: application/vnd.tcpdump.pcap; name="ipvs_port_reuse.pcap"
Content-Disposition: attachment; filename="ipvs_port_reuse.pcap"
Content-Transfer-Encoding: base64

1MOyoQIABAAAAAAAAAAAAAAABAABAAAA+X6LZFtrAwBKAAAASgAAAFJUABIc31JUANtMVQgA
RQAAPN6+QABABkf7CgAAAgoAAAEQ4QTSmm3wXAAAAACgAvrwFDEAAAIEBbQEAggKZuTRoAAA
AAABAwMH+X6LZHhuAwBKAAAASgAAAFJUANtMVVJUABIc3wgARQAAPAAAQAA/Bie6CgAAAQoA
AAIE0hDheYXcmZpt8F2gEv6IFDEAAAIEBbQEAggKjNQbZGbk0aABAwMH+X6LZJpwAwBCAAAA
QgAAAFJUABIc31JUANtMVQgARQAANN6/QABABkgCCgAAAgoAAAEQ4QTSmm3wXXmF3JqAEAH2
FCkAAAEBCApm5NGhjNQbZPl+i2QBegMASAAAAEgAAABSVADbTFVSVAASHN8IAEUAADrmU0AA
PwZBaAoAAAEKAAACBNIQ4XmF3JqabfBdgBgB/hQvAAABAQgKjNQbZmbk0aFoZWxsbwr5fotk
9noDAEIAAABCAAAAUlQAEhzfUlQA20xVCABFAAA03sBAAEAGSAEKAAACCgAAARDhBNKabfBd
eYXcoIAQAfYUKQAAAQEICmbk0aSM1Btm+n6LZP1zAQBCAAAAQgAAAFJUABIc31JUANtMVQgA
RQAANN7BQABABkgACgAAAgoAAAEQ4QTSmm3wXXmF3KCAEQH2FCkAAAEBCApm5NTEjNQbZvp+
i2TIeQEAQgAAAEIAAABSVADbTFVSVAASHN8IAEUAADTmVEAAPwZBbQoAAAEKAAACBNIQ4XmF
3KCabfBegBAB/hQpAAABAQgKjNQeiWbk1MT6fotkGogJAEIAAABCAAAAUlQA20xVUlQAEhzf
CABFAAA05lVAAD8GQWwKAAABCgAAAgTSEOF5hdygmm3wXoARAf4UKQAAAQEICozUIG9m5NTE
+n6LZHuMCQBCAAAAQgAAAFJUABIc31JUANtMVQgARQAANAAAQABABibCCgAAAgoAAAEQ4QTS
mm3wXnmF3KGAEAH2f0cAAAEBCApm5NaujNQgbzp/i2SUOgsASgAAAEoAAABSVAASHN9SVADb
TFUIAEUAADxSJ0AAQAbUkgoAAAIKAAABEOEE0tdxJqsAAAAAoAL68BQxAAACBAW0BAIICmbl
vdcAAAAAAQMDBzp/i2QOPQsASgAAAEoAAABSVADbTFVSVAASHN8IAEUAADwAAEAAPwYnugoA
AAEKAAACBNIQ4av73WPXcSasoBL+iBQxAAACBAW0BAIICpb0jT1m5b3XAQMDBzp/i2TPPgsA
QgAAAEIAAABSVAASHN9SVADbTFUIAEUAADRSKEAAQAbUmQoAAAIKAAABEOEE0tdxJqyr+91k
gBAB9hQpAAABAQgKZuW92Zb0jT06f4tkS0cLAEgAAABIAAAAUlQA20xVUlQAEhzfCABFAAA6
WflAAD8GzcIKAAABCgAAAm+DEOGr+91k13EmrIAYAf4ULwAAAQEICpb0jT9m5b3ZaGVsbG8K
On+LZAhJCwA2AAAANgAAAFJUABIc31JUANtMVQgARQAAKAAAQABABibOCgAAAgoAAAEQ4W+D
13EmrAAAAABQBAAAHVwAADx/i2RO8QwAQgAAAEIAAABSVAASHN9SVADbTFUIAEUAADRSKUAA
QAbUmAoAAAIKAAABEOEE0tdxJqyr+91kgBEB9hQpAAABAQgKZuXFdZb0jT08f4tksvMMADYA
AAA2AAAAUlQA20xVUlQAEhzfCABFAAAoAABAAD8GJ84KAAABCgAAAgTSEOGr+91kAAAAAFAE
AAD8ygAA

--------------IWmv06F5K0ydfM57bOh0gNny--
