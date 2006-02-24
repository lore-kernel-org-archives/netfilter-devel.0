From: Piotr Chytla <pch@packetconsulting.pl>
Subject: Re: problem with ipset and 2.4.31, again...
Date: Fri, 24 Feb 2006 15:32:51 +0100
Message-ID: <20060224143251.GA27210@packetconsulting.pl>
References: <20060224111012.GA26233@packetconsulting.pl>
	<Pine.LNX.4.58.0602241409590.10263@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0602241409590.10263@blackhole.kfki.hu>
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

On Fri, Feb 24, 2006 at 02:15:37PM +0100, Jozsef Kadlecsik wrote:
> > ipset from patch-o-matic-ng(r6345) fails to compile on 2.4.31/32, Problem and
> > solution is the same as this :
> 
> We are at rev 6470 in p-o-m-ng, I think you are using a too old release.
>
Sorry my mistake, It wasn't rev 6345, I'm using ftp snapshot
patch-o-matic-ng-20060222. 
 
> lockhelp.h dependecy was completely removed from ipset so
> CONFIG_NETFILTER_DEBUG does not affect it at all.
>

ip_set.c from patch-o-matic-ng-20060222/patchlets/set/linux/net/ipv4/netfilter/ip_set.c

MD5(./ip_set.c)= 4f7670b61c1c19ef53efa9f8b3967ae5

I'm geting this while compiling 2.4.31 with ipset:

gcc -D__KERNEL__ -I/storage/src/linux-2.4.31-ipset/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i686
-DMODULE -DMODVERSIONS -include /storage/src/linux-2.4.31-ipset/include/linux/modversions.h  -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_set  -DEXPORT_SYMTAB -c ip_set.c
ip_set.c: In function `ip_set_hash_del':
ip_set.c:133: warning: passing arg 1 of `write_lock' from incompatible pointer type
ip_set.c:142: error: structure has no member named `lock'
ip_set.c: In function `ip_set_hash_add':
ip_set.c:158: warning: passing arg 1 of `write_lock' from incompatible pointer type
ip_set.c:180: error: structure has no member named `lock'
ip_set.c: In function `ip_set_testip_kernel_Rsmp_4db03336':
ip_set.c:224: warning: passing arg 1 of `read_lock' from incompatible pointer type
ip_set.c:236: error: structure has no member named `lock'
ip_set.c: In function `ip_set_addip_kernel_Rsmp_9c8f3e11':
ip_set.c:253: warning: passing arg 1 of `read_lock' from incompatible pointer type
ip_set.c:265: error: structure has no member named `lock'
ip_set.c: In function `ip_set_delip_kernel_Rsmp_e054472f':
ip_set.c:284: warning: passing arg 1 of `read_lock' from incompatible pointer type
ip_set.c:296: error: structure has no member named `lock'
ip_set.c: In function `ip_set_register_set_type_Rsmp_313ca42e':
ip_set.c:329: warning: passing arg 1 of `write_lock' from incompatible pointer type
ip_set.c:341: error: structure has no member named `lock'
ip_set.c: In function `ip_set_unregister_set_type_Rsmp_8e327a2d':
ip_set.c:348: warning: passing arg 1 of `write_lock' from incompatible pointer type
ip_set.c:358: error: structure has no member named `lock'
ip_set.c: In function `ip_set_bindip':
ip_set.c:570: warning: passing arg 1 of `write_lock' from incompatible pointer type
ip_set.c:576: error: structure has no member named `lock'


/pch
 
-- 
Dyslexia bug unpatched since 1977 ...
exploit has been leaked to the underground.
