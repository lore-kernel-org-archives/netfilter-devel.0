From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net] netfilter: nf_conntrack: prevent uninit-value in
 gc_worker
Date: Tue, 17 Jul 2018 18:15:52 +0200
Message-ID: <20180717161552.6etdphougrsaoi57@breakpoint.cc>
References: <20180712004037.197064-1-edumazet@google.com>
 <20180712090044.lwukow7nqzzht67g@breakpoint.cc>
 <9a877bfc-67f3-2242-a681-5814dc1c1dd4@gmail.com>
 <CACT4Y+buOFu2CLkGoqupQSHYpuxDsUPPdfSmpDa_6Sht9LesTQ@mail.gmail.com>
 <20180717135931.dexnlxtnv3daunit@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180717135931.dexnlxtnv3daunit@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> What could be possible is that another core is registering/unregistering
> the conntrack hooks in parallel, I guess in that case we could have:
[..]

much simpler explanation: dccp connection tracker.
