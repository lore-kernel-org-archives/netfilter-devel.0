From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: 7/7 [NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard for
 extensions
Date: Thu, 4 Sep 2008 11:41:39 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809041139000.7250@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808131925160.13154@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0808131943180.13154@fbirervta.pbzchgretzou.qr> <48BFFA79.701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37165 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbYIDPll (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Sep 2008 11:41:41 -0400
In-Reply-To: <48BFFA79.701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-04 11:10, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> [NETFILTER]: Implement NFPROTO_UNSPEC as a wildcard for extensions
>> 
>> When a match or target is looked up using xt_find_{match,target},
>> Xtables will also search the NFPROTO_UNSPEC module list. This allows
>> for protocol-independent extensions (like xt_time) to be reused from
>> other components (e.g. arptables, ebtables).
>> 
>> Extensions that take different codepaths depending on match->family
>> or target->family of course cannot use NFPROTO_UNSPEC within the
>> registration structure (e.g. xt_pkttype).
>
> Nice work. You should have compile tested it though.

I sure did. But somehow, this one with xt_string somehow crept in,
reappeared several times in my own tree(s), mostly due to unsynchronized
clone/rebase/push -f.
