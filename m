From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Mon, 16 Feb 2009 18:17:11 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161813450.26651@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence> <49994643.8010001@trash.net> <499971CC.6040903@netfilter.org> <49997247.3010105@trash.net> <4999787C.7050203@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46043 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbZBPRRM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:17:12 -0500
In-Reply-To: <4999787C.7050203@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 15:30, Pablo Neira Ayuso wrote:
>
>>> Hm, you mean the name "mangle" or the name of the option
>>> "--mangle-mac-d"? This is what we currently have in kernel
>>> mainline and arptables userspace, it's not my fault :). I can
>>> send you a patch to fix it with a consistent naming without
>>> breaking backward compatibility both in kernel and user-space.
>>
>> Great, I wasn't aware that this already existed in userspace :)
>
> Yes, it's hosted by the ebtables projects. That tool really need
> some care.

It would indeed. The problem though is, that I, who originally
wanted to unify arptables into iptables (as a start, because it
has not diverged as much as ebtables), have thrown the towel on
that on the grounds of libiptc being such a beast[1], and that 
developers' time would be better spent on (fasten seatbelts)
duplicating xtables/iptables (once more) with the goal of
creating an NFPROTO-agnostic table structure instead that
obsoletes ip,ip6,arp and ebtables in one go.

[1] http://marc.info/?t=122633592000011&r=1&w=2
