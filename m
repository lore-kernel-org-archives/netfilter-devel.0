From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: explicit module dependency between br_netfilter and physdev
Date: Thu, 02 Oct 2014 13:16:03 +0200
Message-ID: <F9B207C3-A2C6-484C-9EA8-C412CD3066C6@trash.net>
References: <1412242912-3622-1-git-send-email-pablo@netfilter.org> <20141002105103.GF1803@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org, stephen@networkplumber.org
To: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37265 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaJBLQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 07:16:09 -0400
In-Reply-To: <20141002105103.GF1803@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 2. Oktober 2014 12:51:03 MESZ, schrieb Florian Westphal <fw@strlen.de>:
>Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> You can use physdev to match the physical interface enslaved to the
>> bridge device. This information is stored in skb->nf_bridge and it is
>> set up by br_netfilter. So, this is only available when iptables is
>> used from the bridge netfilter path.
>> 
>> Since 34666d4 ("netfilter: bridge: move br_netfilter out of the
>core"),
>> the br_netfilter code is modular. To reduce the impact of this
>change,
>> we can autoload the br_netfilter if the physdev match is used since
>> we assume that the users need br_netfilter in place.
>
>Good idea.  I'd suggest to add a dummy dependency and have userspace
>take
>care of this -- just like we do for nf_defrag.

Yes, the symbol dependency is enough, we don't need any manual module refcounting.

