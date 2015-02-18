From: Ana Rey <ana@soleta.eu>
Subject: Re: [v4 nf 0/5] Named counter objects support in nft
Date: Wed, 18 Feb 2015 13:17:46 +0100
Message-ID: <54E482EA.3060306@soleta.eu>
References: <cover.1423075525.git.ana@soleta.eu> <20150217172301.GA7558@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:55479 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbbBRMQw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 07:16:52 -0500
In-Reply-To: <20150217172301.GA7558@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



On 17/02/15 18:23, Patrick McHardy wrote:
> On 04.02, Ana Rey Botello wrote:
>> Hi,
>>
>> With this patchset, we add named counter objects support. It is similar
>> to nfacct in iptables.
> 
> Thanks for doing this work. I have some patches coming up very soon
> which have kind of an intersection with your work, so I'd ask for a
> little bit of patience until we can integrate them.

ok, I'll be patient.

> 
> Basically what my patches will do is to allow to statically or
> dynamically "stateify" and expression type, including counters.
> Your patches are one of the missing pieces in doing that, however
> we most likely want to change them in a way that they not only
> allow access to counter objects, but any kind of expression. Its
> a rather minor change to your work, but requires some things I'm
> still working on. Hope to have something ready by the end of next
> week.
> 
> I'll keep you posted.
> 
