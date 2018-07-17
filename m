From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: nf_conntrack: prevent uninit-value in
 gc_worker
Date: Tue, 17 Jul 2018 15:59:31 +0200
Message-ID: <20180717135931.dexnlxtnv3daunit@breakpoint.cc>
References: <20180712004037.197064-1-edumazet@google.com>
 <20180712090044.lwukow7nqzzht67g@breakpoint.cc>
 <9a877bfc-67f3-2242-a681-5814dc1c1dd4@gmail.com>
 <CACT4Y+buOFu2CLkGoqupQSHYpuxDsUPPdfSmpDa_6Sht9LesTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Dmitry Vyukov <dvyukov@google.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+buOFu2CLkGoqupQSHYpuxDsUPPdfSmpDa_6Sht9LesTQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Dmitry Vyukov <dvyukov@google.com> wrote:
> What should have been initialized it?

nf_ct_refresh_acct()

> I assume it should have been happened in between init_conntrack and
> nf_conntrack_confirm, because nf_conntrack_confirm already adds to an
> uninit timeout value.

Yes.

> Since we got only 3 such reports and no reproducer, I would suspect
> that there is some race involved. Is it possible that timeout
> initialization (presumably a call to nf_ct_refresh_acct) happens after
> and non-atomically with the corresponding connection state update, so
> that the call to nf_conntrack_confirm sneaks before it?

Unconfirmed conntrack isn't in the hash table, so all events should
occur in order on same cpu:
1. allocation (init_conntrack)
2. timeout initialisation (via l4 tracker, can be generic one too)
3. nf_conntrack_confirm (insertion in hash table)

What could be possible is that another core is registering/unregistering
the conntrack hooks in parallel, I guess in that case we could have:

1. allocation (init_conntrack)
(other cpu: remove conntrack hooks)
(other cpu: add conntrack hooks)
3. nf_conntrack_confirm (insertion in hash table)

Just a theory of course.
In any case patch looks good to me.
