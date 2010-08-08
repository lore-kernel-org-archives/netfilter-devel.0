From: "Yossi Weihs" <yw@seafire.com>
Subject: newbie: writing custom target, need help with getting it to work
Date: Sun, 8 Aug 2010 16:20:09 -0400
Message-ID: <00fe01cb3737$19358d20$4ba0a760$@com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00FF_01CB3715.9223ED20"
Cc: <yw@seafire.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns2.server274.com ([64.14.68.54]:56598 "EHLO server274.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754183Ab0HHUVN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Aug 2010 16:21:13 -0400
Content-Language: en-us
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_00FF_01CB3715.9223ED20
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi List,

I have been working on a custom netfilter target to help with some =
in-house
testing. I=92m running Fedora 13 and building within xtables-addons v =
1.2.6 ;
I have gotten both the kernel module and library to build correctly =
within
the xtables-addons build enviroment, and am inserting the kernel module =
with
no errors. When trying to create a rule with my target, I get the =
cryptic
error:

iptables --verbose --table filter --insert INPUT --protocol TCP -m state
--state ESTABLISHED --jump TAP --device TAPPY
TAP=A0 tcp opt -- in * out *=A0 0.0.0.0/0=A0 -> 0.0.0.0/0=A0 state =
ESTABLISHED TAP
dev:TAPPY=20
iptables: No chain/target/match by that name.

I=92m seeing dev:TAPPY, which I think means the user space library =
correctly
parsed the parameters. Since I manually inserted the module, I know =
it=92s
there, although I did not see the module initialization kernel info
message... Any ideas on where to look next? I have attached my target =
code.

Thanks!


Joseph "Yossi" Weihs, CTO

SeaFire Micros, Inc.
39 Dodge St, #319
Beverly, MA 01915

http://www.seafire.com
yw@seafire.com
http://twitter.com/SeaFireMicros


*************************************************************************=
***
*********************************************
This message is a PRIVATE communication. This message and all =
attachments
are a private communication sent by SeaFire and may be confidential or
protected by privilege. If you are not the intended recipient, you are
hereby notified that any disclosure, copying, distribution or use of the
information contained in or attached to this message is strictly
prohibited.=A0 Please notify the sender of the delivery error by =
replying to
this message, and then delete it from your system.=A0 Thank you.
*************************************************************************=
***
*********************************************


------=_NextPart_000_00FF_01CB3715.9223ED20
Content-Type: application/octet-stream;
	name="xt_TAP.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="xt_TAP.c"

/*=0A=
 *	"TAP" target extension for Xtables=0A=
 *=0A=
 */=0A=
#include <linux/ip.h>=0A=
#include <linux/module.h>=0A=
#include <linux/route.h>=0A=
#include <linux/skbuff.h>=0A=
#include <net/checksum.h>=0A=
#include <net/icmp.h>=0A=
#include <net/ip.h>=0A=
#include <net/ip6_route.h>=0A=
#include <net/route.h>=0A=
#include <linux/netfilter/x_tables.h>=0A=
=0A=
#include <linux/version.h>=0A=
#if LINUX_VERSION_CODE <=3D KERNEL_VERSION(2, 6, 25)=0A=
#include <asm/semaphore.h>=0A=
#else=0A=
#include <linux/semaphore.h>=0A=
#endif=0A=
=0A=
=0A=
#if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)=0A=
#	define WITH_CONNTRACK 1=0A=
#	include <net/netfilter/nf_conntrack.h>=0A=
#endif=0A=
#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)=0A=
#	define WITH_IPV6 1=0A=
#endif=0A=
=0A=
#include "compat_xtables.h"=0A=
#include "seabatch.h"=0A=
#include "xt_TAP.h"=0A=
=0A=
static unsigned int=0A=
tap_tg4(struct sk_buff **pskb, const struct xt_target_param *par)=0A=
{=0A=
	const struct xt_tap_tginfo *info =3D par->targinfo;=0A=
	struct xt_tap_tginfo *private_info =3D (struct xt_tap_tginfo =
*)par->targinfo;=0A=
	const struct sk_buff *skb =3D *pskb;=0A=
	const struct iphdr *iph;=0A=
	const struct tcphdr *tcph;=0A=
	int iptcphlen,tcpdlen,idx,fidx;=0A=
	void * buf;=0A=
=0A=
	iph =3D ip_hdr(skb);=0A=
	// verify source and dest address match=0A=
	fidx =3D -1;=0A=
	for (idx =3D 0; idx < info->filter_count; ++idx) {=0A=
		if ((iph->saddr =3D=3D info->tap_filter[idx].source) ||=0A=
		    (iph->daddr =3D=3D info->tap_filter[idx].dest)) {=0A=
			fidx =3D idx;=0A=
		}=0A=
	}=0A=
	if (-1 =3D=3D fidx) {=0A=
		return XT_CONTINUE;=0A=
	}=0A=
	iptcphlen =3D ip_hdrlen(skb);=0A=
=0A=
	// Time to grab mutex=0A=
	if (down_interruptible(private_info->tap_filter[fidx].lock)) {=0A=
		printk(KERN_CRIT "TAP down_interruptible %s %d\n",__FILE__,__LINE__);=0A=
		return XT_CONTINUE;=0A=
	}=0A=
=0A=
	// snip some code removed=0A=
	=0A=
	// Fall out=0A=
	fallout:=0A=
	// Release Mutex=0A=
	up(private_info->tap_filter[fidx].lock);=0A=
	// done=0A=
	return XT_CONTINUE;=0A=
}=0A=
=0A=
#ifdef WITH_IPV6=0A=
static unsigned int=0A=
tap_tg6(struct sk_buff **pskb, const struct xt_target_param *par)=0A=
{=0A=
	printk (KERN_WARNING "TAP IPV6 not supported");=0A=
	return XT_CONTINUE;=0A=
}=0A=
#endif /* WITH_IPV6 */=0A=
=0A=
static int tap_tg_check(const struct xt_tgchk_param *par)=0A=
{=0A=
	/* Const access to fields set by user space */=0A=
	const struct xt_tap_tginfo 	 *info =3D par->targinfo;=0A=
	/* non-const access to private TARGET module fields; TODO: find more =
elegant=0A=
	   way to store TARGET specific private information */=0A=
	struct xt_tap_tginfo *private_info =3D par->targinfo;=0A=
	int err;=0A=
=0A=
	private_info->handle =3D Splinter_Register_TAP(info->dev);=0A=
=0A=
	if (!private_info->handle) {=0A=
		/* Failed to register! */=0A=
		printk (KERN_ERR "TAP sorry failed to get handle.\n");=0A=
		return -EINVAL;=0A=
	}=0A=
=0A=
	err =3D Copy_Splinter_Table(private_info->handle, =0A=
	                          &private_info->tap_filter[0],=0A=
	                          MAX_FILTERS_PER_TARGET * =0A=
	                            sizeof(struct SeaFire_Connection_Filter));=0A=
=0A=
	if (-1 =3D=3D err) {=0A=
		private_info->handle =3D 0;=0A=
		return -EINVAL;=0A=
	}=0A=
=0A=
	private_info->filter_count =3D err;=0A=
=0A=
	printk(KERN_INFO "SeaFire TAP Check Passed\n");=0A=
	=0A=
	return 0;=0A=
}=0A=
=0A=
/* dunno why - this does not exist in current rev of library=0A=
static int tap_tg_dtor(const struct xt_tgchk_param *par)=0A=
{=0A=
	const struct xt_tap_tginfo *info =3D par->targinfo;=0A=
=0A=
	return 0;=0A=
}=0A=
*/=0A=
=0A=
static struct xt_target tap_tg_reg[] __read_mostly =3D {=0A=
	{=0A=
		.name       =3D "TAP",=0A=
		.revision   =3D 0,=0A=
		.family     =3D NFPROTO_IPV4,=0A=
		.target     =3D tap_tg4,=0A=
		.targetsize =3D sizeof(struct xt_tap_tginfo),=0A=
		.checkentry =3D tap_tg_check,=0A=
//		.destroy    =3D tap_tg_dtor,=0A=
		.me         =3D THIS_MODULE,=0A=
	},=0A=
#ifdef WITH_IPV6=0A=
	{=0A=
		.name       =3D "TAP",=0A=
		.revision   =3D 0,=0A=
		.family     =3D NFPROTO_IPV6,=0A=
		.target     =3D tap_tg6,=0A=
		.targetsize =3D sizeof(struct xt_tap_tginfo),=0A=
		.checkentry =3D tap_tg_check,=0A=
//		.destroy    =3D tap_tg_dtor,=0A=
		.me         =3D THIS_MODULE,=0A=
	},=0A=
#endif=0A=
};=0A=
=0A=
static int __init tap_tg_init(void)=0A=
{=0A=
	printk(KERN_INFO "SeaFire TAP Installed\n");=0A=
	return xt_register_targets(tap_tg_reg, ARRAY_SIZE(tap_tg_reg));=0A=
}=0A=
=0A=
static void __exit tap_tg_exit(void)=0A=
{=0A=
	printk(KERN_INFO "SeaFire TAP Removed\n");=0A=
	xt_unregister_targets(tap_tg_reg, ARRAY_SIZE(tap_tg_reg));=0A=
	/* Free up any allocated memory */=0A=
}=0A=
=0A=
module_init(tap_tg_init);=0A=
module_exit(tap_tg_exit);=0A=

------=_NextPart_000_00FF_01CB3715.9223ED20--

