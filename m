From: Rolf Fokkens <rolf@rolffokkens.nl>
Subject: No more PHYSIN in iptables INPUT rules in kernel 3.11.3
Date: Thu, 17 Oct 2013 12:44:26 +0200
Message-ID: <CE858BF4.B9C9%rolf@rolffokkens.nl>
References: <CE858BED.B9C9%rolf@rolffokkens.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: Jasper Siero <jasper.siero@target-holding.nl>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55315 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab3JQKod (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:44:33 -0400
Received: by mail-wi0-f174.google.com with SMTP id cb5so8159143wib.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2013 03:44:32 -0700 (PDT)
In-Reply-To: <CE858BED.B9C9%rolf@rolffokkens.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

FYI: I created the following redhat bugzilla bug:
https://bugzilla.redhat.com/show_bug.cgi?id=1019743Since upgrading to
Fedora 19 kernel iptables processing apparently no longer has the notion
of a PHYSIN device (in case of a bridge interface) for INPUT rules. PHYSIN
is no longer available in iptables logging, nor is it matched by any
rules.Version-Release number of selected component (if applicable):
kernel-3.11.3-201.fc19.x86_64

Steps to Reproduce:
1. Add iptables rules like this:
   iptables -I INPUT -i br1 -m conntrack --ctstate NEW  -j LOG
--log-prefix NOPHYSIN
   iptables -I INPUT -i br1 -m conntrack --ctstate NEW  -m physdev
--physdev-in vnet+ -j LOG --log-prefix PHYSIN
2. Note that the logging shows only NOPHYSIN messages and no PHYSIN
messages
3. Note that the counters for the first rule are updated while the
counters for the second remain 0

Additional info:
Previous (working kernel): kernel-3.9.4-200.fc18.x86_64

A selection from our syslog demonstrates the issue. At about 10:10:00 the
system was rebooted, after that PHSYIN is lost for INPUT rules:

Oct 14 09:49:11 kvm02 kernel: [1552500.679452] iptables:DROPREST:IN=br1
OUT= PHYSIN=vnet4 MAC=c8:60:00:8a:5b:6a:52:54:00:9c:c5:fb:08:00
SRC=129.125.100.130 DST=129.125.100.102 LEN=328 TOS=0x00 PREC=0x00 TTL=64
ID=0 DF PROTO=UDP SPT=68 DPT=67 LEN=308
Oct 14 10:05:01 kvm02 kernel: [1553450.653313] iptables:DROPREST:IN=br1
OUT= PHYSIN=em1 MAC=c8:60:00:8a:5b:6a:00:d0:00:97:4c:00:08:00
SRC=178.32.8.224 DST=129.125.100.102 LEN=44 TOS=0x00 PREC=0x00 TTL=56
ID=5582 PROTO=TCP SPT=111 DPT=29609 WINDOW=16384 RES=0x00 ACK SYN
URGP=0 
Oct 14 10:12:12 kvm02 kernel: [   32.913511] iptables:DROPREST:IN=br1 OUT=
MAC=c8:60:00:8a:5b:6a:00:d0:00:97:4c:00:08:00 SRC=122.136.196.116
DST=129.125.100.102 LEN=82 TOS=0x00 PREC=0x00 TTL=114 ID=13667 PROTO=UDP
SPT=18485 DPT=53 LEN=62
Oct 14 10:19:25 kvm02 kernel: [  465.852664] iptables:DROPREST:IN=br1 OUT=
MAC=c8:60:00:8a:5b:6a:52:54:00:9c:c5:fb:08:00 SRC=129.125.100.130
DST=129.125.100.102 LEN=70 TOS=0x00 PREC=0x00 TTL=63 ID=44769 DF PROTO=UDP
SPT=41923 DPT=53 LEN=50


