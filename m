From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH net-next v18 0/8] sched: Add Common Applications Kept Enhanced (cake) qdisc
Date: Fri, 01 Jun 2018 19:42:12 +0200
Message-ID: <87r2lq9zez.fsf@toke.dk>
References: <152776056580.16347.7216549227396672873.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Georgios Amanakis <gamanakis@gmail.com>,
        Pete Heist <peteheist@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org, cake@lists.bufferbloat.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <152776056580.16347.7216549227396672873.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> This patch series adds the CAKE qdisc, and has been split up to ease
> review.
>
> I have attempted to split out each configurable feature into its own patc=
h.
> The first commit adds the base shaper and packet scheduler, while
> subsequent commits add the optional features. The full userspace API and
> most data structures are included in this commit, but options not
> understood in the base version will be ignored.

Hmm, there seems to be a lockup issue being triggered when running CAKE
at high speeds (>40 Gbps in my tests). Please drop this series for now,
we'll return for 4.19 with a revised version.

-Toke
