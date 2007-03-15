From: "Samuel Jean" <jix@bugmachine.ca>
Subject: [BROKEN] ipt_ wrappers for xt_ functions (WAS: Problems Compiling
	Geoip on linux-2.6.21-rc3)
Date: Thu, 15 Mar 2007 14:36:34 -0000
Message-ID: <twig.1173969394.3980@bugmachine.ca>
References: <200703080637.WAA05730@NickAndBarb.net>
Reply-To: jix@bugmachine.ca
Cc: jengelh@gmx.de, kaber@trash.net
To: "Nick Pasich" <NewsLetters@NickAndBarb.net>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070314165817.GA22948@69.17.112.251>
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

On Wed, Mar 14, 2007, Nick Pasich <NewsLetters@NickAndBarb.net> said:

Hi Nick --

> Problem occurr when compiling geoip for Linux Kernel 2.6.21rc1 -> rc3

Yes. And I guess all patchlets from POM are broken too.  They all use
ipt_register/unregister functions which have been removed here :

[NETFILTER]: {ip,ip6}_tables: remove x_tables wrapper functions
author	Jan Engelhardt <jengelh@gmx.de>
	Wed, 7 Feb 2007 23:11:19 +0000 (15:11 -0800)
committer	David S. Miller <davem@sunset.davemloft.net>
	Thu, 8 Feb 2007 20:39:19 +0000 (12:39 -0800)
commit	6709dbbb1978abe039ea4b76c364bf003bf40de5
tree	fd0349415e398f9bc984461974a64c7024035356	tree | snapshot
parent	e1fd0586b04d624c597834320d9e57d6f2f4b878	commit | diff
[NETFILTER]: {ip,ip6}_tables: remove x_tables wrapper functions

Use the x_tables functions directly to make it better visible which
parts are shared between ip_tables and ip6_tables.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

Patrick --

How do we workaround the missing wrappers ? Another #if KERNEL_VERSION
declarations ?

> Kernel: arch/i386/boot/bzImage is ready  (#1)
>   Building modules, stage 2.
>   MODPOST 256 modules
> WARNING: "ipt_unregister_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
> WARNING: "ipt_register_match" [net/ipv4/netfilter/ipt_geoip.ko] undefined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2

Best regards,
Samuel
