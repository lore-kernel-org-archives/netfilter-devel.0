From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 14/24] [NETFILTER]: Use bool in nf_conntrack_l4proto
Date: Thu, 3 Apr 2008 17:39:39 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804031725030.1301@fbirervta.pbzchgretzou.qr>
References: <1207134726-28689-1-git-send-email-jengelh@computergmbh.de> <3fe7a3dd723a0f2c303559ef46e3d7d67702db57.1207134547.git.jengelh@computergmbh.de> <47F4F103.5070007@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52911 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756174AbYDCPjk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2008 11:39:40 -0400
In-Reply-To: <47F4F103.5070007@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-04-03 17:00, Patrick McHardy wrote:
>
> ERROR: use tabs not spaces
> #32: FILE: include/net/netfilter/nf_conntrack_l4proto.h:48:
> +^I            unsigned int dataoff);$
>
> <hundreds more>
>
> Jan, applying your patches is getting too much work, I'm
> dropping everything I haven't applied yet. Your other patches
> also have checkpatch errors, I'll fix those up :|
>
> Some hints for the future to make this easier for both of us:
>
> - submit small batches, split into logical units

This sets me up a bit.. sometimes it's "should have folded these"
(like the const annotation patches that were at the start of
the series), then it's "smaller batches" :-/


> - avoid style changes like this, especially when the entire file
>   uses a consistent style:
>
>>  -static int icmpv6_pkt_to_tuple(const struct sk_buff *skb,
>>  -			       unsigned int dataoff,
>>  -			       struct nf_conntrack_tuple *tuple)

allow me the remark of "consistently odd", as you can see what a
change in indent does when spaces are not used in the right
place. But whatever, yeah.

>>  +static bool
>>  +icmpv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
>>  +                    struct nf_conntrack_tuple *tuple)
>
> - run checkpatch

Not before I rip out that incredibly stupid "use tabs" warning.
The warning may be right for users who apparently have not dealt
with patch submitting process a lot, but for longtime contributers
that get their style right the 1st time it's just wrong.
     That program has no sense for when spaces are needed.
The style I used and use (tabs=indent, spaces=align - it only makes
sense) was always fine by you, but now it's not because
checkpatch says so?

> - don't mix cleanups with real changes
> - run sparse with endian checks
> - compile test all the code your changing, including CONFIG_COMPAT

Will do.
