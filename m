From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: xt_hashlimit: do not allow empty names
Date: Fri, 2 Feb 2018 12:56:36 +0100
Message-ID: <20180202115636.wwsftihixrg46gps@salvia>
References: <1517154099.3715.77.camel@gmail.com>
 <1517162045.3715.78.camel@gmail.com>
 <20180202114938.jxsaun6w3hnfedfz@salvia>
 <20180202115522.bmuukhfib4harcoy@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180202115522.bmuukhfib4harcoy@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Feb 02, 2018 at 12:55:22PM +0100, Pablo Neira Ayuso wrote:
> On Fri, Feb 02, 2018 at 12:49:38PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > 
> > Or place this in the core, something like:
> > 
> > bool net_valid_name(const char *name, size_t len)
> > {
> >         ...
> > }
> > 
> > then use it from dev_valid_name()
> > 
> > bool dev_valid_name(const char *name)
> > {
> >         return net_valid_name(name, IFNAMSIZ);
> > }
> 
> Just to clarify, I think I prefer this approach, probably other
> subsystem can benefit from this generic approach too.
> 
> BTW, I wonder if we should use strnlen() instead of strlen() in
> dev_valid_name(), I guess this not useful for device name since they
> are guaranteed to be nul-terminated, but netfilter this would be good
> given userspace can send us a non nul-terminated string. But in
> general, I think it doesn't harm to use strnlen() in dev_valid_name().

Argh sorry, I'm talking about the hypothetical net_valid_name()
function, not dev_valid_name() itself.
