From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6, first
 preview
Date: Wed, 19 Jan 2005 09:30:38 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501190900080.10476@blackhole.kfki.hu>
References: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org,
	Robert Iakobashvili <roberti@GoNetworks.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050119004332.GA12629@roonstrasse.net>
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

Hi,

On Wed, 19 Jan 2005, Max Kellermann wrote:

> I have worked a bit on porting the H.323 conntrack module to Linux
> 2.6. Here is my first preview. Both connection tracking and NAT work
> well in my home network (gnomemeeting and ohphone, tunneling
> disabled).
>
> It's still the old brute force method, no real protocol evaluation is
> performed. I will implement that the "right" way after the port to the
> Linux 2.6 API is finished and tested. The current algorithm is not
> recommended for production environments, because it is insecure,
> sometimes buggy and horribly inefficient.

Yes, exactly. That was why I refrained from porting it to 2.6...

If you want to write a decent helper, then ethereal has got a H.323 (ASN)
decoder written in C, which could probably be re-used. :-)

> The patches apply to patch-o-matic-ng from svn. Due to recent API
> changes, you need kernel 2.6.10-mm2 or later. I am currently using
> 2.6.11-rc1.

As for the patch, thus we would overwrite the 2.4 version in pom-ng.
Please put all the files into a h323-conntrack-nat/linux-2.6 subdirectory
so that the support for 2.4 can be kept. (The README.newpatches file
in pom-ng describes in detail how to create a new patch.)

Please note, pom-ng is unable to take into account the extra version.
As requirements you should speficy something like

Requires: linux-2.6 >= 2.6.11

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
