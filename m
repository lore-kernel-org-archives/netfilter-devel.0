From: Bryan Duff <bduff@astrocorp.com>
Subject: xt_statistic.c - the statistic match
Date: Fri, 09 Jan 2009 16:20:59 -0600
Message-ID: <4967CDCB.3080306@astrocorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([75.160.64.129]:21532 "EHLO
	mail.astrocorp.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754377AbZAIWlQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:41:16 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id 2D2886313A
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Jan 2009 16:20:16 -0600 (CST)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id myrO2t2CxxEG for <netfilter-devel@vger.kernel.org>;
	Fri,  9 Jan 2009 16:20:14 -0600 (CST)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id CA50563139
	for <netfilter-devel@vger.kernel.org>; Fri,  9 Jan 2009 16:20:14 -0600 (CST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

... gets out of sync in nth mode.  The count seems to be off somehow.  
At some point the count is off - in my case I have 3 rules that are 
consecutive:

//snip - iptables rules
iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 
10.10.11.0/24 -m statistic --mode nth --every 3 --packet 0 -j MARK 
--set-mark 1
iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 -d 
10.10.11.0/24 -m statistic --mode nth --every 3 --packet 1 -j MARK 
--set-mark 2 iptables -t mangle -A PREROUTING -i ethX -s 10.10.10.0/24 
-d 10.10.11.0/24 -m statistic --mode nth --every 3 --packet 2 -j MARK 
--set-mark 3
//end snip

Now when I accept those mark values, the packet counts which should be 
almost equal are off by large numbers (hundreds of thousands):

//snip - iptables -L
  978189 1210792980 ACCEPT     all  --  ethX   *       
10.10.10.0/24        10.10.11.0/24    MARK match 0x1
 2182885 2704995300 ACCEPT     all  --  ethX   *       
10.10.10.0/24        10.10.11.0/24    MARK match 0x2
 2289382 2862482240 ACCEPT     all  --  ethX   *       
10.10.10.0/24        10.10.11.0/24    MARK match 0x3
 1417708 1807169776 MARK       all  --  ethX   *       
10.10.10.0/24        10.10.11.0/24    MARK set 0x1
 1417708 1807169776 ACCEPT     all  --  ethX   *       
10.10.10.0/24        10.10.11.0/24    MARK match 0x1
//end snip

The mark target rule above should never see a packet.

//snip - printks show the goofiness (in this example packet 0, and 
packet 2 are on the same count)
...
Jan 9 22:35:32 localhost kernel: packet 0: count 1 of every 2
Jan 9 22:35:32 localhost kernel: packet 1: count 0 of every 2
Jan 9 22:35:32 localhost kernel: packet 2: count 1 of every 2
Jan 9 22:35:32 localhost kernel: packet 0: count 2 of every 2
Jan 9 22:35:32 localhost kernel: packet 0 to 0
Jan 9 22:35:32 localhost kernel: packet 1: count 1 of every 2
Jan 9 22:35:32 localhost kernel: packet 2: count 2 of every 2
Jan 9 22:35:32 localhost kernel: packet 2 to 0
...
//end snip


The last rule mark/accept should _never_ be hit (they should all be 
accepted by then). 

//snip (line 33 of xt_statistic.c - nth mode ...
        switch (info->mode) {
        case XT_STATISTIC_MODE_RANDOM:
                if ((net_random() & 0x7FFFFFFF) < 
info->u.random.probability)
                        ret = !ret;
                break;
        case XT_STATISTIC_MODE_NTH:
                info = info->master;
                spin_lock_bh(&nth_lock);
                if (info->u.nth.count++ == info->u.nth.every) {
                        info->u.nth.count = 0;
                        ret = !ret;
                }
                spin_unlock_bh(&nth_lock);
                break;
        }
//end snip

Why would the nth mode case screw up?  With 3 consecutive rules, I'll 
have problems after perhaps 500,000 packets (but it varies wildly). 

At some point of the 3 rules, 2 rules have the same packet count - so of 
3 packets: one is double counted, and 1 is missed.

Random mode has no problems, but it doesn't do any locking and keeps no 
state.  Even when I change nth from a switch statement to a if/else, I 
still have the same problem (I was thinking that maybe the compiler 
didn't like spin locks in a case statement).  I'm not sure if this is a 
locking issue, how if it is, how to resolve (spin_lock_irq?).

This module is very simple, and I see similar usage of 
spin_[un]lock_bh() all over the place.  I hope I'm missing something.

Thanks.

-Bryan
