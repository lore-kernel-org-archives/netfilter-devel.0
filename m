From: Masahide NAKAMURA <nakam@linux-ipv6.org>
Subject: Re: [NETFILTER]: ip6_tables: Support MH match.
Date: Fri, 9 Feb 2007 15:22:35 +0900
Message-ID: <200702091522.35894.nakam@linux-ipv6.org>
References: <200701260953.l0Q9rvv9022736@toshiba.co.jp>
	<200702010141.l111fFVK020135@toshiba.co.jp>
	<Pine.LNX.4.64.0702021158250.3560@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: nakam@linux-ipv6.org, rdenis@simphalempin.com,
	netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0702021158250.3560@blackhole.kfki.hu>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

# FYI, now I've subscribed the netfilter-devel list.

> > >> > > What happens if a node (including a non-Linux one) receives a MH packet
> > >> > > with a non-none next protocol? I might be wrong, but I would assume it
> > >> > > parses it, at least in some cases.
> >
> > The node will send ICMP parameter problem back with code depending on
> > whether the node supports MH or not.
> > If it supports, the code is 0 (erroneous header field) as RFC3775.
> > Otherwise, the code 1 (unrecognized Next Header).
> >
> >
> > >> > > If this is trye, this patch might introduce a trivial way to evade
> > >> > > firewall rules, as firewall admins will assume the next protocol is
> > >> > > none, while it might not be.
> > >> > >
> > >> > > Of course, I could be plain wrong, since I do not know MH.
> >
> > If the sender creates MH with nexthdr=TCP for example,
> > it may go through the firewall which is configured even MH=ACCEPT
> > TCP=DROP. However, the receiver cannot handle it as TCP.
> >
> > Can I add nexthdr check, or should I rewrite it as "-m" module
> > to treat MH as an extension header?
> 
> Personally, I'd prefer a check in the MH match that makes sure there is no 
> more header, simply because we cannot assume that the sender keeps the 
> rules.

Thanks for your comment.
OK, I'll write additional patch to check no more header.



-- 
Masahide NAKAMURA
