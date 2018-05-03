From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: Silently dropped UDP packets on kernel 4.14
Date: Thu, 3 May 2018 11:42:41 +0200
Message-ID: <20180503094241.mfos3scewpct3dnu@unicorn.suse.cz>
References: <CAKfDRXjop-G3qOZg+P6Mb4VKjvgJejScv9VHaJHB5OJBnqG30w@mail.gmail.com>
 <CAKfDRXj5oSD9-LKRbS_LYko+WEKwwunUq0L35G3t7Gi9Om74zw@mail.gmail.com>
 <20180501222406.fy5rph2t4dzndhu2@breakpoint.cc>
 <CAKfDRXhkXvF==6LQFOG3Rf4dH4QVVUxR=1cXZoM2FPQksGdxwg@mail.gmail.com>
 <CAKfDRXiO7qKHGLf5faSy7g_f1p9budJLXS9-uZWLPgyx3OAJbA@mail.gmail.com>
 <20180503050345.iyasach2ogf25dt3@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503050345.iyasach2ogf25dt3@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 03, 2018 at 07:03:45AM +0200, Florian Westphal wrote:
> Kristian Evensen <kristian.evensen@gmail.com> wrote:
> > I went for the early-insert approached and have patched
> 
> I'm sorry for suggesting that.
> 
> It doesn't work, because of NAT.
> NAT rewrites packet content and changes the reply tuple, but the tuples
> determine the hash insertion location.
> 
> I don't know how to solve this problem.

It's an old problem which surfaces from time to time when some special
conditions make it more visible. When I was facing it in 2015, I found
this thread from as early as 2009:

  https://www.spinics.net/lists/linux-net/msg16712.html

In our case, the customer was using IPVS in "one packet scheduling" mode
(it drops the conntrack entry after each packet) which increased the
probability of insert collisions significantly. Using NFQUEUE 

We were lucky, though, as it turned out the only reason why customer
needed connection tracking was to make sure fragments of long UDP
datagrams are not sent to different real servers. For newer kernels
after commit 6aafeef03b9d ("netfilter: push reasm skb through instead of
original frag skbs"), this was no longer necessary so that they could
disable connection tracking for these packets.

For older kernels without this change, I tried several ideas, each of
which didn't work for some reason. We ended up with rather hacky
workaround, not dropping the packet on collision (so that its conntrack
wasn't inserted into the table and was dropped once the packet was
sent). It worked fine for our customer but like the early insert
approach, it wouldn't work with NAT.

One of the ideas I had was this:

  - keep also unconfirmed conntracks in some data structure
  - check new packets also against unconfirmed conntracks
  - if it matches an unconfirmed conntrack, defer its processing
    until that conntrack is either inserted or discarded

But as it would be rather complicated to implement without races and
harming performance, I didn't want to actually try it until I would
run out of other ideas. With NAT coming to the play, there doesn't seem
to be many other options.

Michal Kubecek
