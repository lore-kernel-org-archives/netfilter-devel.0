From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 6.2 released
Date: Tue, 29 Mar 2011 22:06:47 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1103292203470.8469@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1103272124170.3535@blackhole.kfki.hu> <4D91E7D7.3070000@msgid.tls.msk.ru> <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu> <4D923687.6030003@msgid.tls.msk.ru> <4D923AD5.6090907@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D923AD5.6090907@msgid.tls.msk.ru>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Mar 2011, Michael Tokarev wrote:

> 29.03.2011 23:44, Michael Tokarev ?????:
> > 29.03.2011 23:23, Jozsef Kadlecsik wrote:
> >> On Tue, 29 Mar 2011, Michael Tokarev wrote:
> >>
> >>> ipset-6.2/kernel/net/netfilter/ipset/Kconfig file
> >>> appears to be some net/netfilter/Kconfig file from
> >>> linux source tree (from one directory level up),
> >>> patched with NETFILTER_XT_SET.  It gets included
> >>> into itself recursively.
> >>
> >> Yes, you are right, I fixed it in the ipset git tree. Thanks!
> > 
> > Actually I'm not sure at all this file is needed.
> > 
> > With current Kbuild file, it builds everything as
> > modules, the only CONFIG_FOO in use is IP_SET_MAX
> > which can be specfied in the upper-level Kconfig
> > (in net/netfilter/Kconfig).
> 
> Maybe something like this:
> 
> net/netfilter/ipset/Makefile:
> ip_set-y := ip_set_core.o ip_set_getport.o pfxlen.o
> 
> obj-$(CONFIG_IP_SET) += ip_set.o
> 
> obj-$(CONFIG_IP_SET_BITMAP_IP) += ip_set_bitmap_ip.o
> obj-$(CONFIG_IP_SET_BITMAP_IPMAC) += ip_set_bitmap_ipmac.o
> obj-$(CONFIG_IP_SET_BITMAP_PORT) += ip_set_bitmap_port.o
> 
> obj-$(CONFIG_IP_SET_HASH_IP) += ip_set_hash_ip.o
> obj-$(CONFIG_IP_SET_HASH_IPPORT) += ip_set_hash_ipport.o
> obj-$(CONFIG_IP_SET_HASH_IPPORTIP) += ip_set_hash_ipportip.o
> 
> obj-$(CONFIG_IP_SET_HASH_NET) += ip_set_hash_net.o
> obj-$(CONFIG_IP_SET_HASH_IPPORTNET) += ip_set_hash_ipportnet.o
> obj-$(CONFIG_IP_SET_HASH_NETPORT) += ip_set_hash_netport.o
> obj-$(CONFIG_IP_SET_LIST_SET) += ip_set_list_set.o
> ---- cut ----
> 
> net/netfilter/Kbuild.ipset:
> obj-$(CONFIG_XT_SET) += xt_set.o
> obj-$(CONFIG_IP_SET) += ipset/
> --- cut ---
> 
> (this should go to net/netfilter/Makefile in the upstream
> kernel sources; ditto for the Kconfig bits).
> 
> This is all, obviously, about integration into mainline
> kernel.
> 
> Do you plan to include the whole thing into mainline kernel?

Actually, it's already in net-next, so yes :-). And with the Makefiles you 
suggested above.

The Kconfig and the Makefiles are all right in net-next.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
