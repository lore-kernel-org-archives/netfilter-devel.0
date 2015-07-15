From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Wed, 15 Jul 2015 19:46:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507151937160.528@nerf40.vanv.qr>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de> <1436964819-28109-3-git-send-email-jengelh@inai.de> <20150715162442.GA22476@salvia> <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr> <20150715165515.GA4177@salvia>
 <alpine.LSU.2.20.1507151907560.1320@nerf40.vanv.qr> <20150715173035.GA5675@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37758 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbbGORqH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 13:46:07 -0400
In-Reply-To: <20150715173035.GA5675@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-07-15 19:30, Pablo Neira Ayuso wrote:
>> The printing via iptables -S was not the problem.
>> The patch is about that no AH/ESP packets were matched when using
>> just "-m esp" because of the implied --espspi 0:0.
>
>Without your patch:
>
>iptables -A INPUT -p ah
>
># iptables-save
>...
>-A INPUT -p ah -m ah --ahspi 0

That should not happen. -p implies -m only magically if one of the
options is used, i.e. "-p ah" alone should never imply "-m ah".

# XTABLES_LIBDIR=$PWD/extensions iptables/xtables-multi main4 -A z -p ah
# XTABLES_LIBDIR=$PWD/extensions iptables/xtables-multi main4 -S z
-N z
-A z -p ah


Second, without my patch:

# XTABLES_LIBDIR=$PWD/extensions iptables/xtables-multi main4 -A z -p ah -m ah
# XTABLES_LIBDIR=$PWD/extensions iptables/xtables-multi main4 -S z
-A z -p ah -m ah --ahspi 0

And that was the bug: --ahspi 0 is undesired behavior for when --ahspi
is never specified.


Printing it differently is a separate concern one can think about,
but with a separate patch. :-)
