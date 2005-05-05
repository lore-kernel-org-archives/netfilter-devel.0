From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 5 May 2005 08:36:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505050833580.21246@blackhole.kfki.hu>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
	<Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
	<7174b1e40504140101b5138e0@mail.gmail.com>
	<425E3032.2060409@outerspace.dyndns.org>
	<Pine.LNX.4.61.0504141340130.28938@filer.marasystems.com>
	<425E6E4C.2010406@outerspace.dyndns.org>
	<42780DE4.9060808@outerspace.dyndns.org>
	<Pine.LNX.4.58.0505040909090.18836@blackhole.kfki.hu>
	<42787CEE.1090503@outerspace.dyndns.org>
	<Pine.LNX.4.58.0505040947330.18836@blackhole.kfki.hu>
	<4278D431.5000606@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <4278D431.5000606@outerspace.dyndns.org>
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

On Wed, 4 May 2005, Jonas Berlin wrote:

> >>And if that flag was set, netfilter would also assert that the return
> >>value of the target in question is IPT_CONTINUE ?
> >
> > No, targets may return other values. Something like this
>
> I know. But my point was, _should_ these targets with the "cascade flag"
> set be allowed to return anything else?
>
> For example LOG, MARK, CONNMARK and CLASSIFY targets always return
> IPT_CONTINUE. I could agree that NF_DROP could also be allowed if a bad
> packet was recognized or some other problem. But should NF_STOLEN or
> NF_REPEAT or others really be allowed from these targets with "cascade
> flag" set? If there wasn't any restriction on the return value, I don't
> know if there's much point of having a cascade flag either?

In my opinion cascade targets should return IPT_CONTINUE. They may
return NF_DROP in error conditions, but other return values are not
allowed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
