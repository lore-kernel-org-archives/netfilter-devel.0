From: Anton VG <anton.vazir@gmail.com>
Subject: rateest usage problem - slightly lost
Date: Sun, 31 May 2009 19:18:17 +0500
Message-ID: <c4b050a10905310718h110e127cg6ee114cff0bc2f8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:46343 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbZEaOSQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 May 2009 10:18:16 -0400
Received: by ewy24 with SMTP id 24so7287435ewy.37
        for <netfilter-devel@vger.kernel.org>; Sun, 31 May 2009 07:18:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi friends,

Am a little lost with using of the rateest target.

I'm trying to match if one of my interfaces have load over 2000kbit
but it does not seem to work.
While trying to understand the MAN page I'm a little lost - while man
gives example on the comparing the delta, but even trying the simpler
case it does not work for me.

my example s simpler - i just want to know if one interface have load
X to mark packets (to route them later to interface y) - and it does
not seem to work at all.

# iptables -t mangle -A POSTROUTING -o eth0.3810 -j RATEEST
--rateest-name fiber --rateest-interval 250ms --rateest-ewma 0.5s
# iptables -t mangle -A POSTROUTING -o eth0.3811 -j RATEEST
--rateest-name satellite --rateest-interval 250ms --rateest-ewma 0.5s
# iptables -t mangle -A PREROUTING -s 82.198.22.27/32 -m rateest
--rateest1 fiber --rateest-bps1 2000kbit --rateest-gt -j MARK
--set-mark 4
# iptables -t mangle -A PREROUTING -s 82.198.22.27/32 -m rateest
--rateest1 fiber --rateest-bps1 2000kbit --rateest-lt -j MARK
--set-mark 7

iptables -nL -v -t mangle gives

Chain PREROUTING (policy ACCEPT 302M packets, 151G bytes)
 pkts bytes target     prot opt in     out     source               destination
 1426  140K MARK       all  --  *      *       82.198.22.27
0.0.0.0/0           rateest match fiber bps gt 0 MARK xset
0x4/0xffffffff
    0     0 MARK       all  --  *      *       82.198.22.27
0.0.0.0/0           rateest match fiber bps lt 0 MARK xset
0x7/0xffffffff


May anyone give me a piece of clue?
