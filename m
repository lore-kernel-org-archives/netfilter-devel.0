From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] tcp window tracking initial port to 2.6
Date: Mon, 8 Mar 2004 15:41:22 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0403081540320.10575-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.33.0403081111190.10575-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <Pine.LNX.4.33.0403081111190.10575-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Mar 2004, Jozsef Kadlecsik wrote:

> > I spent my sunday evening in porting the tcp window tracking system to
> > the 2.6.x tree. Attached to this email the incremental fix to the CVS
> > and the merge to the 2.6.x tree.
>
> Sorry, that was a waste of time. I had already done the porting, but
> because pom-ng is not fully ready yet, I haven't put it into the cvs.

I have added my 2.6 port of the tcp-window-tracking code to pom-ng in
cvs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
