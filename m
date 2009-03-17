From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 15:41:32 +0100
Message-ID: <49BFB69C.6030004@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl> <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0903171535210.3657@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Holger Eitzenberger <holger@eitzenberger.org>,
	pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49435 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbZCQOlf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 10:41:35 -0400
In-Reply-To: <alpine.LSU.2.00.0903171535210.3657@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> xt_conntrack for example has a nicer effect: once you add a rule that
> contains it, it will load nf_conntrack_ipv{4,6}, which in turn causes
> Netfilter to start tracking in the first place.
> 
> So along the lines, xt_connbytes could pin a module (or perhaps
> something more light-weight) to ultimately signify
> "forced-activation"/"deactivation-impossible", much like you cannot
> remove nf_conntrack while an xt_conntrack-using rule is in place.

It doesn't have to be forced IMO, but yes, the automatic enabling
should be similar to what xt_conntrack does.

> Then only one thing remains. As for nf_conntrack, once it is loaded,
> it picks up already-running connections (and loses them as soon
> as you rmmod it). This is not the case with accounting as far as I
> have observed yesterday - only new connections get to have (or
> not to have) an acct structure; existing ones are not modified
> or picked up like conntrack does.

Thats not possible using ct_extend.
