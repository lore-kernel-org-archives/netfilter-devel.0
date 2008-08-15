From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: manpages: add missing rateest documentation
Date: Fri, 15 Aug 2008 15:53:00 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151552380.10478@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808142030200.32487@fbirervta.pbzchgretzou.qr> <48A5745C.90407@netfilter.org> <alpine.LNX.1.10.0808150924430.27140@fbirervta.pbzchgretzou.qr> <48A5BEF4.4020201@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47678 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYHOTxB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:53:01 -0400
In-Reply-To: <48A5BEF4.4020201@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2008-08-15 13:37, Pablo Neira Ayuso wrote:

>Jan Engelhardt wrote:
>> On Friday 2008-08-15 08:19, Pablo Neira Ayuso wrote:
>>> Jan Engelhardt wrote:
>>>> commit c918302a6d769055da8627bcf189f9e64d3073f9
>>>> Author: Jan Engelhardt <jengelh@medozas.de>
>>>> Date:   Thu Aug 14 20:24:58 2008 -0400
>>>>
>>>> manpages: add missing rateest documentation
>>> This looks good to me but, since Patrick is the author of this
>>> target/match, I'll leave it to him to apply this patch.
>> 
>> The changelog had some nice usage notes, see linux kernel commit
>> 50c164a81f1c0dfad056f99e5685537fdd0f07dd.
>
>Make sense. Applied, thanks.

The libxt_rateest.man patch is missing. Forgot to git-add? :)
