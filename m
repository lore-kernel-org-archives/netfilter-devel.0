From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 0/2] xt_cgroups fix
Date: Fri, 27 Mar 2015 09:48:55 +0100
Message-ID: <55151977.8010702@iogearbox.net>
References: <cover.1427394874.git.daniel@iogearbox.net> <20150327004016.GE3545@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: daniel@zonque.org, fw@strlen.de, a.perevalov@samsung.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:54695 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbbC0ItB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 04:49:01 -0400
In-Reply-To: <20150327004016.GE3545@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/27/2015 01:40 AM, Pablo Neira Ayuso wrote:
> On Thu, Mar 26, 2015 at 08:14:46PM +0100, Daniel Borkmann wrote:
>> Hi Pablo,
>>
>> here's a possible fix for xt_cgroups that was previously reported
>> by Daniel Mack.
>>
>> I respinned the set based on your previous feedback wrt tw sockets.
>>
>> The first patch refactors common helpers, which is later on being
>> used by the actual fix. Please see individual patches for details.
>>
>> I have rebased it against nf-next as in the previous version.
>
> The existing cgroup support for nf_tables is quite broken (see patch
> attached), that needs some care too. Would you also help us to get
> that in good shape? It will be half way done after your patches.

Sure, I can look into that. If you're ok, I would look into that
after the xt_cgroup bits are carved out first.

> This makes me think that you can place something generic to fetch the
> sk_classid:
>
>          static bool nf_sock_classid(u32 *sk_classid);
>
> this would go in net/ipv4/netfilter/nf_sock_ipv4.c.
>
> And also the ipv6 version:
>
> static bool nf_sock6_classid(u32 *sk_classid);
>
> so we can use the same function to fetch the sk_classid that can be
> shared by xt and nft. Please, give it another spin, you can probably
> come up with a better interface.

Ok, will do. Thanks for the feedback, Pablo!

> BTW, we also have two more families: inet and bridge. Inet should be
> easy, it's basically a special family for dual-stack setups, 'inet'
> chain see both ipv4 and ipv6 traffic, you have to use pkt->ops->pf to
> pass this to right ipv4/ipv6 function.
>
> See net/netfilter/nft_reject.c, net/ipv{4,6}/nft_reject_ipv{4,6}.c and
> net/netfilter/nft_reject_inet.c for reference.
>
> Thanks.
>

