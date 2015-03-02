From: Markus Koetter <koetter@rrzn.uni-hannover.de>
Subject: Re: [RFC] nft trace
Date: Mon, 02 Mar 2015 08:33:51 +0100
Message-ID: <54F4125F.60203@rrzn.uni-hannover.de>
References: <54F35515.5050807@rrzn.uni-hannover.de> <20150302002004.GA9881@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout2.uni-hannover.de ([130.75.2.114]:42644 "EHLO
	mailout2.uni-hannover.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbCBHdx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 02:33:53 -0500
In-Reply-To: <20150302002004.GA9881@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 03/02/2015 01:20 AM, Pablo Neira Ayuso wrote:
> I think it's reasonable to have some tracing command intergrated into
> nft, but we still have to discuss the text output layout.

The formatting of the "TRACE: " prefix as used by nftables does not=20
provide the same amount of information as with iptables.
In case of goto/jump/return, the rulenum provided by iptables allows=20
accessing a rule which has the "target" set, so you can see where to=20
you'll end up.
In nftables, the rulenum provided in case of a return is worthless -=20
there is no such rule, so you can't lookup the target.
=46or goto/jump it may be possible to lookup the target in some cases, =
but=20
at least not when using vmap.

So - if we'll discuss the text output layout anyway, let's consider the=
=20
text input as well. Specifying the target explicitly in case of a=20
jump/goto/return in the "TRACE: " prefix provides value.


MfG
Markus K=F6tter
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
