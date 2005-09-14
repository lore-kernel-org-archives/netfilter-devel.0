From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.2.3 released
Date: Thu, 15 Sep 2005 00:09:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0509150006520.25481@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0509141241230.23538@blackhole.kfki.hu>
	<200509141002.40185.teastep@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <200509141002.40185.teastep@shorewall.net>
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

On Wed, 14 Sep 2005, Tom Eastep wrote:

> > I'm happy to announce ipset 2.2.3. The changes compared to the previous
> > release are:
>
> > - lockhelp.h was removed from the 2.6.13 kernel tree, ip_set.c is
> >   updated accordingly (Cardoso Didier, Samir Bellabes)
>
> This patch doesn't seem to be in svn or in the snapshot tarball linked
> from your site.

Oops, you're right: that chunk was forgotten to commit in svn. It's fixed
by now in svn and the snapshot is updated as well. Thank you the fast
reporting.

Best regards,
jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
