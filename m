From: Florian Westphal <fw@strlen.de>
Subject: Re: __nf_register_net_hook jump label splat
Date: Sun, 30 Sep 2018 19:39:30 +0200
Message-ID: <20180930173930.kyciz5vll23vpjw2@breakpoint.cc>
References: <20180929230409.GA27207@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180929230409.GA27207@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Borislav Petkov <bp@alien8.de> wrote:
> Hi people,
> 
> this is something new I'm triggering with rc5 + tip/master while rc4 +
> tip/master is fine. Any ideas?

No clue.  I don't see any netfilter changes between rc4 & rc5.
I just tried to set up a bridge on rc5 with call-iptables=1
and I see no such splat.

> If I had to guess, it looks like this thing:
> 
> #ifdef HAVE_JUMP_LABEL
>         static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
> #endif

Strange, these static keys have been there for years.
Any chance you could send your .config or bisect this?

Thanks.
