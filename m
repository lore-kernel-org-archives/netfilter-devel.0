From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/1 linux-next] netfilter: conntrack: fix kmemleak false
 positive
Date: Thu, 22 Sep 2016 23:56:15 +0200
Message-ID: <20160922215615.GA18577@breakpoint.cc>
References: <1474487397-11032-1-git-send-email-fabf@skynet.be>
 <20160921210253.GB24153@breakpoint.cc>
 <49958525.49207.1474566957624.open-xchange@webmail.nmp.proximus.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49958525.49207.1474566957624.open-xchange@webmail.nmp.proximus.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fabian Frederick <fabf@skynet.be> wrote:
> Hello Florian,
> 
>         First problem is solved: table gets cleared 3 minutes earlier
> but I still have kmemleak before running the following:
> 
> echo scan > /sys/kernel/debug/kmemleak
> cat /sys/kernel/debug/kmemleak
> Nothing
> echo scan > /sys/kernel/debug/kmemleak
> cat /sys/kernel/debug/kmemleak
> -> rsyslogd
> 
> I talked about false positive because everything is cleared later.

Hmm, I fear this is a real bug and not false positive.

Should be possible to confirm this via slabinfo:

grep nf_conntrack /proc/slabinfo

The active objects should match the conntrack count.
(conntrack -C, or wc -l < /proc/....).

> > > unreferenced object 0xffff88003b0e6600 (size 248):
> > >   comm "rsyslogd", pid 1595, jiffies 4294741312 (age 7.343s)
> > >   ...
> > >   backtrace:
> > >     [] kmemleak_alloc+0x23/0x40
> > >     [] kmem_cache_alloc+0xd9/0x180
> > >     [] __nf_conntrack_alloc.isra.50+0x48/0x170
> > >     [] nf_conntrack_in+0x3a2/0x5f0
> > >     [] ipv4_conntrack_local+0x40/0x50
> > >     [] nf_iterate+0x5d/0x70
> > >     [] nf_hook_slow+0x5f/0xb0
> > >     [] __ip_local_out+0xad/0xe0
> > >     [] ip_local_out+0x17/0x40
> > >     [] ip_send_skb+0x14/0x40
> > >     [] udp_send_skb+0x91/0x260
> > >     [] udp_sendmsg+0x2f5/0x950
> > >     [] inet_sendmsg+0x60/0x90
> > >     [] sock_sendmsg+0x33/0x40
> > >     [] SYSC_sendto+0xee/0x160
> > >     [] SyS_sendto+0x9/0x10

Hmm, so we leak when allocating conntrack for outgoing packet.
Do you do any filtering (DROP) in output/postrouting?

> > > (248 bytes being an nf_conn structure)
> > >
> > > Those structures being cleared in gc_worker() later on we can't talk
> > > about unreferenced object so this patch uses kmemleak_not_leak() to
> > > prevent those warnings.
> >
> > If thats the case, why is kmemleak complaining? Are you sure this
> > is a false positive?

Looks like a real bug to me, but I don't see anything obvious so far.
I'll look at this again tomorrow.
