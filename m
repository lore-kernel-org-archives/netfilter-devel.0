From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: extra conntrack stats
Date: Mon, 5 May 2003 10:43:26 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0305051040300.607-100000@blackhole.kfki.hu>
References: <20030501015802.2CB152C2D9@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Harald Welte <laforge@netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20030501015802.2CB152C2D9@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 1 May 2003, Rusty Russell wrote:

> > By adding a data lock to the conntrack entries can solve that
> > (potential) problem. The data lock would make unnecessary the per
> > conntrack helper locks too (unfortunately the buffers introduced in the
> > zerocopy patch undo that).
>
> Yeah, per-entry locks make sense I think.  I can change the helpers to
> do an skb_copy (suggested by Alexey) which will be lockless, or just
> implement the damn non-linear search.

I afraid the non-linear search is not general enough. We have to support
protocols which carry structures in the payload and in that case the
non-linear search would be a nightmare.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
