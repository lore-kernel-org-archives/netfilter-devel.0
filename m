From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: I don't understand what goes where, very confused about POM-ng
Date: Wed, 5 May 2004 20:33:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405052012520.31198-100000@blackhole.kfki.hu>
References: <4099210C.40309@rtij.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <netfilter-devel@rtij.nl>
In-Reply-To: <4099210C.40309@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martijn,

On Wed, 5 May 2004, Martijn Lievaart wrote:

> Using CVS of today 5/5/2004.
>
> I'm trying to port the psd match to 2.6. The C code is ready (not much
> of a change needed). However POM will not apply the headerfile from the
> linux/ tree, I need to copy it to the linux-2.6 tree. I would expect
> that everything in the linux tree would also be applied, eventually
> overridden by something in the linux-2.6 tree. Why else have seperate
> linux-2.4 trees?

No, every tree is for their own version(s) and they must contain
everything which is needed for a patch to be complete installed. The
reason for this is that there can be missing/added files in different
kernel trees. For example how could a program figure out in the case

	linux/include/linux/netfilter_foo.h
	linux/include/linux/netfilter_bar.h

	linux-2.6/include/linux/netfilter_foo.h

that linux/include/linux/netfilter_bar.h is required for linux-2.6 or not?

> By now I gather that POM-ng tries to find a best match, and does this
> independently for the ladds and the files (and the patches as well?). I
> find this very confusing, but I think this is by design?

Yes, this is by design. Or call it a feature :-).

> Anyhow, I looked at a couple of other patches and many have their header
> file only in the linux-tree. Many are also base, so probably already
> applied to any 2.6 kernel, but the why have a linux-2.6 tree in that
> case? One patch where this really breaks is the XOR patch, it does not
> apply to 2.6 because POM-ng does not copy the header.

Then those patches are broken in pom-ng and have to be fixed.

> As an alternative, would it be possible to just create a linux-2.6.patch
> file that applies after the 2.4 patch has applied? This would be a good
> solution because many patches need only minor modifications to newly
> added files (especially only ipt_xxx.c) to make them run under 2.6.

No, that won't go either. What should we do when linux-2.7 comes out and
from some reason there are 2.4, 2.6 versions supported? Should the
linux-2.7.patch depend on linux-2.4.patch and linux-2.6.patch then?

I believe the current behaviour is the most simple and straightforward:
every three contains everything which is required. No cross-dependency.
No magic between trees. Simpler pom scripts. Also, we support broken out
patches. How could that fitted into other designs easily?

I hope that helps and makes pom-ng clear.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
