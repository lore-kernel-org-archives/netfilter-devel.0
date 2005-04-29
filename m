From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Fri, 29 Apr 2005 09:14:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42627BC4.8070103@trash.net>
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

On Sun, 17 Apr 2005, Patrick McHardy wrote:

> Pablo Neira wrote:
> > Now I've changed my mind :).
> >
> > I think that we can identify a connection with both the original and
> > reply tuple. Since a connection is represented by means of a conntrack,
> > if a user kills a conntrack via ctnetlink, he's willing to kill the
> > connection that the conntrack represents, and not to such conntrack itself.
>
> It depends on by what criteria the user selects the conntrack. I might
> choose to kill/remark/... every connection that has transfered more than
> X bytes, in which case I don't want to touch a new connection with the
> same tuples that has transfered less than X. How can we handle this
> and similar cases without an identifier that is unique over time?

That is independent from id/tuple, because the condition is formulated in
the terms of transferred bytes.

I don't like id either. Conntrack can uniquely identified by

- src/dst tuples, globally, even in a cluster
- the pointer of the conntrack entry, locally

Why should we need another unique id?

Looking at the last changes, I think it'd be much more better to port
ip_queue to nfnetlink than to reserve another netlink ID: the hooks in
nfnetlink are already there. I know that'd create backward compatibility
issues at the existing queue applications, though... :-(

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
