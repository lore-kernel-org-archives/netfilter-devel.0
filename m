From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: RE: [Ebtables-devel] [PATCH] IPv6 dnat/snat support
Date: Tue, 12 Feb 2008 03:43:55 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802120333400.29955@fbirervta.pbzchgretzou.qr>
References: <mailman.53487.1201131436.6775.ebtables-devel@lists.sourceforge.net><3F25FE8C477E9E4FB3D42C2FF937C08A72D8D4@orsmsx423.amr.corp.intel.com><3F25FE8C477E9E4FB3D42C2FF937C08A767706@orsmsx423.amr.corp.intel.com><1201303354.2909.1.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A82039A@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802070130120.23855@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CA7F@orsmsx423.amr.corp.intel.com><Pine.LNX.4.64.0802080126020.25157@fbirervta.pbzchgretzou.qr><3F25FE8C477E9E4FB3D42C2FF937C08A85CB14@orsmsx423.amr.corp.intel.com><1202494854.2895.11.camel@localhost.localdomain><3F25FE8C477E9E4FB3D42C2FF937C08A85D069@orsmsx423.amr.corp.intel.com><1202664082.2907.5.camel@localhost.localdomain>
 <3F25FE8C477E9E4FB3D42C2FF937C08A85D440@orsmsx423.amr.corp.intel.com>
 <3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: "Tseng, Kuo-Lang" <kuo-lang.tseng@intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58748 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182AbYBLCn5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Feb 2008 21:43:57 -0500
In-Reply-To: <3F25FE8C477E9E4FB3D42C2FF937C08A897BDA@orsmsx423.amr.corp.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Feb 11 2008 18:26, Tseng, Kuo-Lang wrote:
>
>Hi Jan, have you posted the corresponding patch to ebtables-devel for
>the kernel patch you posted in here
>http://marc.info/?l=netfilter-devel&m=120182168424052&w=2 ?

I had not posted ebt_ip6(j) to ebtables-devel. I suppose it's because
I did not consider ebtables too vivid, esp. after confirmation
of Bart being not too active 
( http://marc.info/?l=netfilter-devel&m=120083920425755&w=2 ) -- but 
right, I should have Cc'ed at least.


>If not, I can add the code and send an updated patch to ebtables-devel
>to make the v6 support more complete as Bart suggested.
>
>We also need to merge the two kernel patches (your above one and the one
>I sent last Friday). Has your kernel patch been pushed in? If not, I'll
>add my part on top of yours and send an updated patch to
>netfilter-devel. What do you think? 

The patch did not made it in time for 2.6.25-rc1, but I have it
slated for the next possible time - 2.6.26 or maybe someone
lets it slip into the current rcX :)

Yes, please proceed with adding proper nexthdr parsing (one patch)
and layer-4 port inspection (another patch) - perhaps in two patches.


>To quickly summarize what we got: 
>
>- You above kernel patch implements matches for TFCLASS, FLOWLBL,
>NEXTHDR (w/o skipping ext. header), H- OPLIMIT, SRCADDR, and DSTADDR. 
>- My kernel patch implements matches for PROTOCOL (w/ ext. header
>skipped), DPORT, and SPORT and logging for v6.
>
>- My user ebtables patch implements parsing for PROTO, SPORT, and DPORT.
