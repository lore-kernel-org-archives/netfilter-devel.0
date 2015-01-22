From: Patrick Schaaf <netdev@bof.de>
Subject: Funny iptables -L output with 0.0.0.3 netmask
Date: Thu, 22 Jan 2015 12:14:08 +0100
Message-ID: <5101724.aeQA8Siq95@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:45926 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbbAVLOL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 06:14:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

just noticed something funny with "iptables -L" - was always fine in the past, 
e.g. with iptables 1.4.10, but now on a box with iptables 1.4.19 (opensuse 
13.1) I see a funny thing.

Rule:
iptables -A somewhere -s 0.0.0.1/0.0.0.3 -j ACCEPT

Previous / normal list output:
ACCEPT     all  --  0.0.0.1/0.0.0.3      anywhere

Funny output I see now:
ACCEPT     all  --  0.0.0.1/-1           anywhere

The "-1" shows for variations of the nifty mask, too, e.g. /0.0.0.1 or 
/0.0.0.5 or even /127.255.255.255 - apparently anything with a leading 0-bit.

iptables-save output is fine.

Sorry if this is known + maybe already fixed in newer iptables versions...

best regards
 Patrick
