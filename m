From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack.acct has no effect
Date: Wed, 18 Mar 2009 05:32:34 +0100
Message-ID: <49C07962.2050806@trash.net>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl> <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr> <alpine.LSU.2.00.0903171535210.3657@fbirervta.pbzchgretzou.qr> <49BFB69C.6030004@trash.net> <alpine.LSU.2.00.0903171639270.7260@fbirervta.pbzchgretzou.qr>
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
Received: from stinky.trash.net ([213.144.137.162]:64152 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbZCREck (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2009 00:32:40 -0400
In-Reply-To: <alpine.LSU.2.00.0903171639270.7260@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2009-03-17 15:41, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> Then only one thing remains. As for nf_conntrack, once it is loaded,
>>> it picks up already-running connections (and loses them as soon
>>> as you rmmod it). This is not the case with accounting as far as I
>>> have observed yesterday - only new connections get to have (or
>>> not to have) an acct structure; existing ones are not modified
>>> or picked up like conntrack does.
>> Thats not possible using ct_extend.
>>
> I see. It is probably best then to document this behavior in iptables.
> To that end, here are two patches, pullable from
> 
> 	git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (2):
>       libxt_connbytes: minor manpage adustments
>       libxt_connbytes: document nf_ct_acct behavior

Pulled, thanks Jan,
