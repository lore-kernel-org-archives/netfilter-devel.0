From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: tcp-window-tracking vs. pending/24_conntrack-nosysctl.patch
Date: Sat, 5 Apr 2003 16:51:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304051645460.21072-100000@blackhole.kfki.hu>
References: <1049545687.25167.177.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049545687.25167.177.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 5 Apr 2003, Martin Josefsson wrote:

> > > - removed copying the source trees at patch testing (faster processing)
> >
> > Gives a quite nice speedup :)
>
> And makes dependencies fail :(
>
> If patch A requires that patch B is applied before it can apply we are
> screwed :) Nothing is applied during testing so even if patch B tests
> fine, patch A won't apply since it depends on B which wasn't applied.

I see what you mean. Strange, the patches I used at the testing did depend
on each other.

Then if a patch depends on other patches an any of them isn't applied yet,
then stop and ask to apply that missing patch immediately. Thus we can
keep consistency without the need of copying the source trees.

What do you think?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
