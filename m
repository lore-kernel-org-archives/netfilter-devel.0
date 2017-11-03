From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC,WIP 1/5] netfilter: nf_conntrack: move
 nf_ct_netns_{get,put}() to core
Date: Fri, 3 Nov 2017 16:30:44 +0100
Message-ID: <20171103153044.GG9424@breakpoint.cc>
References: <20171103152636.9967-1-pablo@netfilter.org>
 <20171103152636.9967-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171103152636.9967-2-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> So we can call this from other expression that need conntrack in place
> to work.

Acked-by: Florian Westphal <fw@strlen.de>
