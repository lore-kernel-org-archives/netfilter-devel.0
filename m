From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ipv6: fix oops when defragmenting locally
 generated fragments
Date: Thu, 25 Oct 2018 10:18:51 +0200
Message-ID: <20181025081851.fblnz7u4jd4hgdfd@salvia>
References: <CANP3RGeX5=c=Lb+Pkg89zD7zQ_Z1T8oPJRCkorNCdghmofYXxg@mail.gmail.com>
 <20181023144716.19746-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, lorenzo@google.com,
        zenczykowski@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org, maze@google.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181023144716.19746-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 23, 2018 at 04:47:16PM +0200, Florian Westphal wrote:
> Unlike ipv4 and normal ipv6 defrag, netfilter ipv6 defragmentation did
> not save/restore skb->dst.
> 
> This causes oops when handling locally generated ipv6 fragments, as
> output path needs a valid dst.

Applied, thanks!
