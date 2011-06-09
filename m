From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [NEW SOFTWARE] FIRO - Iptables optimization
Date: Thu, 9 Jun 2011 16:34:59 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106091632200.31505@frira.zrqbmnf.qr>
References: <BANLkTinGcunf22dZQr1mX6omuB88eAZZ6A@mail.gmail.com> <alpine.LNX.2.01.1106091530110.22244@frira.zrqbmnf.qr> <BANLkTi=Ggxj5Pv1t8H_S4gqEWGQwP=iWqA@mail.gmail.com> <alpine.LNX.2.01.1106091615510.31505@frira.zrqbmnf.qr>
 <BANLkTikkY=Hcksw7Lb8CvgD+fhDN=TtCJg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tihomir Katic <tihomir.katic@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48342 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036Ab1FIOfA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:35:00 -0400
In-Reply-To: <BANLkTikkY=Hcksw7Lb8CvgD+fhDN=TtCJg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-06-09 16:23, Tihomir Katic wrote:

>>That is purely noise. You need a lot more rules (10000 and up) to
>>measure an effect.
>
>I've been testing, list with 1000 rules, list with 10000 rules, list
>with 50000 rules.
>Searching for minimum time, in 100 tests, etc.
>
>1 MIN ( 1000 single):  0.206000 us
>1 MIN (1000 array):  0.264000 us
>
>1 MIN (10000 single):  0.081400 us
>1 MIN (10000 array):  0.156900 us

It seems you are not executing all rules. How else could 10k rules be 
faster than 1k? You must not use any -j.

What you need is something like:

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
-A INPUT -p tcp -m multiport --dport 1:5,20:25
COMMIT
# Completed on Thu Jun  9 16:33:15 2011

(of course, replicating this to 1000 rules), and then sending yourself 
some packet and measure the RTT.
