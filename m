From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 02/38] netfilter: flowtables: use fixed renew timeout on
 teardown
Date: Fri, 20 Jul 2018 15:32:05 +0200
Message-ID: <20180720133205.nwzir6bro4yd4pjq@breakpoint.cc>
References: <20180720130906.27687-1-pablo@netfilter.org>
 <20180720130906.27687-3-pablo@netfilter.org>
 <2b757614-c824-cc1b-7ebb-925c2e963830@nbd.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
To: Felix Fietkau <nbd@nbd.name>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <2b757614-c824-cc1b-7ebb-925c2e963830@nbd.name>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:
> On 2018-07-20 15:08, Pablo Neira Ayuso wrote:
> > From: Florian Westphal <fw@strlen.de>
> > 
> > This is one of the very few external callers of ->get_timeouts(),
> > 
> > We can use a fixed timeout instead, conntrack core will refresh this in
> > case a new packet comes within this period.
> > 
> > Use of ESTABLISHED timeout seems way too huge anyway.
> It seems to me that this could easily break long-lived connections that
> are idle most of the time.

Problem is that we don't know state of connection, since it was
offloaded.

We don't know if connection 'died' with unacked data (short default
timeout) or not (long default timeout).

So I would prefer to err on the 'evict idle connection that had no
keepalives early' side rather than the 'add dead connection hanging
around forever'.
