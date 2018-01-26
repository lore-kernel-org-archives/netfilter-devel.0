From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: Re: [nf-next] netfilter: Add support for inner IPv6 packet match
Date: Fri, 26 Jan 2018 21:53:49 +0100
Message-ID: <20180126215349.249afcf24283f2b9f2260180@gmail.com>
References: <1516288405-4582-1-git-send-email-amsalam20@gmail.com>
        <1516288405-4582-2-git-send-email-amsalam20@gmail.com>
        <20180125201354.alkb26twrifnngif@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, fw@strlen.de, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        kadlec@blackhole.kfki.hu, uznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:54688 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbeAZUxz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Jan 2018 15:53:55 -0500
In-Reply-To: <20180125201354.alkb26twrifnngif@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo, 

> Hi Ahmed,
> 
> On Thu, Jan 18, 2018 at 04:13:25PM +0100, Ahmed Abdelsalam wrote:
> [...]
> > diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h b/include/uapi/linux/netfilter_ipv6/ip6t_inner6.h
> Matching at inner headers is a very useful, no doubt. Problem is that
> this approach is rather limited since it only allows for matching
> source and destination address at the inner header. I suspect someone
> else will follow up later on to add more fields to this, and we will
> end up having a new version of ip6tables... inside ip6t_inner6 :-).

Most probably it would be me who come to add more features, but i would call it sr6tables :-) 

> 
> nf_tables is a much more flexible framework, we can store the offset
> of this inner header in nft_pktinfo on demand, add new base to
> nft_payload and have access to all matching capabilities from any
> arbitrary offset. I really think this new feature belongs there.

Indeed, I started looking into the nftables implemenation and really convienced it's more convienent. Moreover, I had many issues with the ip6tables performance specially with the increae in the number of rules. However, why don't we have these patches in the kernel? since we have them implemented (some folks still like ip6tables). 

P.S. I'm looking into nftables exthdrs to support SRH.
Thanks, 
Ahmed 
