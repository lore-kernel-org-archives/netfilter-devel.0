From: "Steve Iribarne (GMail)" <netstv@gmail.com>
Subject: marking notification in the kernel
Date: Thu, 2 Apr 2009 10:15:50 -0700
Message-ID: <b4b98b690904021015o2b5c6738qd8e3a39d0bca0e19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:37200 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZDBRPy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:15:54 -0400
Received: by gxk4 with SMTP id 4so1445781gxk.13
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 10:15:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

I am currently writing a driver that uses the mark field in the
sk_buff data structure.

Particulars:

1.4.0 iptables (I want to use 1.4.3 but I'm getting some other strange
thing in my embedded linux world...)
Kernel 2.6.21.7 (mips 64 bit based)
Cavium Processor

So essentially I have dev->hard_start_xmit(..) function pointing to my
tx routine.  I'm noticing that if I setup a mark:

ie.

iptables -t mangle -A OUTPUT -j MARK --set-mark 3
iptables -t mangle -A OUTPUT -j LOG --log-prefix "mangle-out: "
--log-level debug
iptables -t filter -A OUTPUT -j LOG --log-prefix "filter-out: "
--log-level debug
iptables -t mangle -A POSTROUTING -j LOG --log-prefix
"mangle-postroute: " --log-level debug
iptables -t nat -A POSTROUTING -j LOG --log-prefix "nat-postroute: "
--log-level debug

Interfaces:  pow0/pow1 (which is like eth0 and eth1)

pow0: 10.100.100.109/24
pow1: 10.101.100.1/24

If I try to ping 10.100.100.1 (going out pow0) the mark seems to be
removed by the time the mark gets down to my start_xmit routine.  I'm
trying to figure out where it's being removed or is there somewhere
else I should be looking to get the mark?

In the ipt_LOG.c I added a field to print out the MARK (and I snipped
the rest of the message)

mangle-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
filter-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-postroute: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1
LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
nat-postroute: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
filter-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-postroute: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1
LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
filter-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-postroute: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1
LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3
mangle-out: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109 LEN=112
TOS=0x00 PREC=0xC0 TTL=64 ID=49935 MARK=3
filter-out: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109 LEN=112
TOS=0x00 PREC=0xC0 TTL=64 ID=49935 MARK=3
mangle-postroute: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109
LEN=112 TOS=0x00 PREC=0xC0 TTL=64 ID=49935 MARK=3
mangle-out: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109 LEN=112
TOS=0x00 PREC=0xC0 TTL=64 ID=49936 MARK=3
filter-out: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109 LEN=112
TOS=0x00 PREC=0xC0 TTL=64 ID=49936 MARK=3
mangle-postroute: IN= OUT=lo SRC=10.100.100.109 DST=10.100.100.109
LEN=112 TOS=0x00 PREC=0xC0 TTL=64 ID=49936 MARK=3


My debug in the hard_xmit which shows that mark field is 0.

mangle-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3 DF PROTO=ICMP TYPE=8 CODE=0
ID=840 SEQ=1

filter-out: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1 LEN=84
TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3 DF PROTO=ICMP TYPE=8 CODE=0
ID=840 SEQ=1

mangle-postroute: IN= OUT=pow0 SRC=10.100.100.109 DST=10.100.100.1
LEN=84 TOS=0x00 PREC=0x00 TTL=64 ID=0 MARK=3 DF PROTO=ICMP TYPE=8
CODE=0 ID=840

cvm_oct_xmit_pow:[397]-> pow0: Sending to group 14 and mark is 0

The value of mark that I print out is sk_buff->mark.  How can this be??

Thanks in advance for any help you can give me....

back to walking backwards up the stack... :)



-- 
/*
 * Steve Iribarne
 * Software Engineer
 * (aka Grunt)
 */
