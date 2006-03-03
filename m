From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IPSET patches from pom-ng don't apply to 2.6.16-rc5
Date: Fri, 3 Mar 2006 10:20:05 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0603031018470.25603@blackhole.kfki.hu>
References: <44043F49.7050304@gmx.net>
	<Pine.LNX.4.58.0603021228470.22987@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
In-Reply-To: <Pine.LNX.4.58.0603021228470.22987@blackhole.kfki.hu>
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

On Thu, 2 Mar 2006, Jozsef Kadlecsik wrote:

> On Tue, 28 Feb 2006, Carl-Daniel Hailfinger wrote:
>
> > applying the ipset patch from patch-o-matic-ng doesn't work anymore:
> >
> > Welcome to Patch-o-matic ($Revision: 4088 $)!
> >
> > Kernel:   2.6.16, /storage/linux-2.6.16-rc5
> > Iptables: 1.3.5, /storage/iptables-1.3.5
> > Each patch is a new feature: many have minimal impact, some do not.
> > Almost every one has bugs, so don't apply what you don't need!
> > -------------------------------------------------------
> > Already applied:
> >
> > Testing set... not applied
> > The set patch:
> >    Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> >    Status: Beta
> > [...]
> > -----------------------------------------------------------------
> > Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] t
> > unable to find ladd slot in src /tmp/pom-26985/net/ipv4/netfilter/Makefile (./patchlets/set/linux-2.6/./net/ipv4/netfilter/Makefile.ladd)
>
> The marker points from net/ipv4/netfilter/Makefile were moved into
> net/netfilter/Makefile thus those cannot be found anymore.

It is fixed in svn.

Best regards,
Jozsf
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
