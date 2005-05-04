From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 4 May 2005 10:09:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505040947330.18836@blackhole.kfki.hu>
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
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42787CEE.1090503@outerspace.dyndns.org>
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

> Quoting Jozsef Kadlecsik on 2005-05-04 07:16 UTC:
> > What I can see as viable solution is a flag, which tells which targets may
> > be used in cascade and let make it possible to type
> >
> > ... -j LOG -j DROP
>
> And if that flag was set, netfilter would also assert that the return
> value of the target in question is IPT_CONTINUE ?

No, targets may return other values. Something like this

#define IPT_TARGET_ITERATE(e, fn, args...)      \
({                                              \
        unsigned int __i;                       \
        int __ret = 0;                          \
        struct ipt_entry_target *__target;      \
                                                \
        for (__i = sizeof(struct ipt_entry)     \
                   + (e)->target_offset;        \
             __i < (e)->next_offset;            \
             __i += __target->u.target_size) {  \
                __target = (void *)(e) + __i;   \
                                                \
                __ret = fn(__target , ## args); \
                if (__ret != IPT_CONTINUE)      \
                        break;                  \
        }                                       \
        __ret;                                  \
})

would probably work.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
