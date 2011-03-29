From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: [ANNOUNCE] ipset 6.2 released
Date: Wed, 30 Mar 2011 00:02:29 +0400
Message-ID: <4D923AD5.6090907@msgid.tls.msk.ru>
References: <alpine.DEB.2.00.1103272124170.3535@blackhole.kfki.hu> <4D91E7D7.3070000@msgid.tls.msk.ru> <alpine.DEB.2.00.1103292123001.8329@blackhole.kfki.hu> <4D923687.6030003@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4D923687.6030003@msgid.tls.msk.ru>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

29.03.2011 23:44, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 29.03.2011 23:23, Jozsef Kadlecsik wrote:
>> On Tue, 29 Mar 2011, Michael Tokarev wrote:
>>
>>> ipset-6.2/kernel/net/netfilter/ipset/Kconfig file
>>> appears to be some net/netfilter/Kconfig file from
>>> linux source tree (from one directory level up),
>>> patched with NETFILTER_XT_SET.  It gets included
>>> into itself recursively.
>>
>> Yes, you are right, I fixed it in the ipset git tree. Thanks!
>=20
> Actually I'm not sure at all this file is needed.
>=20
> With current Kbuild file, it builds everything as
> modules, the only CONFIG_FOO in use is IP_SET_MAX
> which can be specfied in the upper-level Kconfig
> (in net/netfilter/Kconfig).

Maybe something like this:

net/netfilter/ipset/Makefile:
ip_set-y :=3D ip_set_core.o ip_set_getport.o pfxlen.o

obj-$(CONFIG_IP_SET) +=3D ip_set.o

obj-$(CONFIG_IP_SET_BITMAP_IP) +=3D ip_set_bitmap_ip.o
obj-$(CONFIG_IP_SET_BITMAP_IPMAC) +=3D ip_set_bitmap_ipmac.o
obj-$(CONFIG_IP_SET_BITMAP_PORT) +=3D ip_set_bitmap_port.o

obj-$(CONFIG_IP_SET_HASH_IP) +=3D ip_set_hash_ip.o
obj-$(CONFIG_IP_SET_HASH_IPPORT) +=3D ip_set_hash_ipport.o
obj-$(CONFIG_IP_SET_HASH_IPPORTIP) +=3D ip_set_hash_ipportip.o

obj-$(CONFIG_IP_SET_HASH_NET) +=3D ip_set_hash_net.o
obj-$(CONFIG_IP_SET_HASH_IPPORTNET) +=3D ip_set_hash_ipportnet.o
obj-$(CONFIG_IP_SET_HASH_NETPORT) +=3D ip_set_hash_netport.o
obj-$(CONFIG_IP_SET_LIST_SET) +=3D ip_set_list_set.o
---- cut ----

net/netfilter/Kbuild.ipset:
obj-$(CONFIG_XT_SET) +=3D xt_set.o
obj-$(CONFIG_IP_SET) +=3D ipset/
--- cut ---

(this should go to net/netfilter/Makefile in the upstream
kernel sources; ditto for the Kconfig bits).


This is all, obviously, about integration into mainline
kernel.

Do you plan to include the whole thing into mainline kernel?

Thanks!

/mjt

