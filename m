From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: patch-o-matic updated
Date: Fri, 11 Apr 2003 10:55:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0304111051590.31394-100000@blackhole.kfki.hu>
References: <1049730816.26440.150.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1049730816.26440.150.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On 7 Apr 2003, Martin Josefsson wrote:

> Modifications I've done:
>
> * Disable dependency-checking for reverse and force modes.
> * Add support for empty lines / comments in .depend files.
> * Add support for conflicting dependencies.
> * Re-add support for sourcetree copying which is needed for correct
>   dependency testing (avoids copying when not neccessary).
> * Add some dependencies, both normal and conflicting.
> * Fix testing and applying of userspace patches.
> * Update both kernel- and userspace-patches in userspace/ to make them
>   apply again. Split up into more correct pieces and thus avoid
>   conflicts with other patches.
> * Cleanups which resulted in performance improvements (just continued
>   with Jozsef's cleanups).
> * Fix problem where circular dependencies were falsely indicated.
> * Make userspacepatches work correctly with dependencies.
> * Add support for batch testing (--batch --test).
> * Fix detection of failed hunks with certain patches.
> * More flexible userspace searching.

Hey, that's excellent! Sooner or later we'll have the patch-o-matic
programming language :-).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
