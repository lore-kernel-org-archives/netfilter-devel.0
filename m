From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v19 0/8] sched: Add Common Applications Kept
 Enhanced (cake) qdisc
Date: Tue, 10 Jul 2018 22:56:48 -0700 (PDT)
Message-ID: <20180710.225648.251006161729517659.davem@davemloft.net>
References: <153089141290.14813.1010951705929696896.stgit@alrua-x1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, gamanakis@gmail.com, peteheist@gmail.com,
        ycheng@google.com, ncardwell@google.com, dave.taht@gmail.com,
        netfilter-devel@vger.kernel.org, cake@lists.bufferbloat.net
To: toke@toke.dk
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <153089141290.14813.1010951705929696896.stgit@alrua-x1>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>
Date: Fri, 06 Jul 2018 17:37:19 +0200

> This patch series adds the CAKE qdisc, and has been split up to ease
> review.
> 
> I have attempted to split out each configurable feature into its own patch.
> The first commit adds the base shaper and packet scheduler, while
> subsequent commits add the optional features. The full userspace API and
> most data structures are included in this commit, but options not
> understood in the base version will be ignored.
> 
> The result of applying the entire series is identical to the out of tree
> version that have seen extensive testing in previous deployments, most
> notably as an out of tree patch to OpenWrt. However, note that I have only
> compile tested the individual patches; so the whole series should be
> considered as a unit.

Ok, I decided to apply this even though there are still bits I'm not
%100 happy with.

I don't like the netfilter dependency at all.

You can get the NAT addresses in other ways as I've tried to suggest
in the past.  Your scheme absolutely does not work with act_nat
in the packet scheduler, not any NAT done by XDP/eBPF programs.
