From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Mon, 24 May 2004 09:42:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085384529.1841.8.camel@nienna.balabit>
References: <Pine.LNX.4.33.0405240929001.15131-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405240929001.15131-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-05-24, h keltezéssel 09:31-kor Jozsef Kadlecsik ezt írta:
> >   While thinking on problems with traffic control in user-space proxies,
> > we came to the conclusion, that under some conditions manually setting
> > the connmark value of an already established connection would be really
> > useful. (For example, it would be possible to traffic-limit based on
> > outband authentication decisions.)
> >
> >   I've created a patch for connmark, which registers a getsockopt() and
> > a setsockopt() function for getting/setting the connection mark. The
> > patch is for Linux 2.4.25 + CONNMARK from POM-ng, but theoretically it
> > should apply on any 2.4.x version plus the newest connmark patch.
> 
> I believe ctnetlink would be the proper tool to do conntrack manipulation
> from userspace.

  I completely agree. In fact, it was one of the proposed solutions for
the problem in my initial correspondence with Henrik. However, I don't
consider ctnetlink ready for prime time (e.g. to be used in a production
environment), and my patch has a lot smaller footprint than ctnetlink.

  Of course, ctnetlink will be the proper tool, if it will be stable
enough for production use. Until then, I think that a simple/working
solution is better than nothing...

  BTW, what are the plans for Linux 2.7? Will ctnetlink/netfilter-ha and
pkttables be integrated? (ctnetlink would be especially important...)

-- 
 Regards,
   Krisztian KOVACS
