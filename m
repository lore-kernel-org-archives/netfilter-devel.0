From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 Netlink spec
Date: Wed, 15 Dec 2010 09:51:10 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 15 Dec 2010, Jan Engelhardt wrote:

> On Friday 2010-11-26 20:01, Jozsef Kadlecsik wrote:
> >On Wed, 24 Nov 2010, Jan Engelhardt wrote:
> >
> >> By request of Pablo, I am posting the Xtables2 Netlink interface 
> >> specification for review. Additionally, further documentation and 
> >> toolchain around it is available through the temporary project page at
> >> 
> >> 	http://jengelh.medozas.de/projects/xtables/
> >>  * Runnable userspace library (libnetfilter_xtables)
> >>    with small test-and-debug program
> >[...]
> >
> >Please add fine-grained error reporting to the protocol: in my opinion the 
> >main shortcoming of the current kernel-userspace xtables protocol is the 
> >lack of the proper error reporting. I mean, the new protocol should be 
> >able to carry back which rule caused the error, in the rule whether it was 
> >a general kind of error (ENOMEM), or a table, chain, match or target error 
> >and exactly what was the error at table/chain/match/target level.
> 
> That should not be a problem. However, what do we do with the general
> kind of error that is overly general? A.k.a. the dreaded EINVAL.
> 
> Say a user requested jumping to a chain, but did not give a chain name.
> Normally that would be EINVAL, but EINVAL is overused already.

When I wrote general error I meant the ones where there is no point (or 
cannot be) to specify the nature of the error exactly. Like in the 
example, ENOMEM: it's needles to report which new data field could not be 
allocated. But if the specified chain does not exists, that must not be 
masked by a general EINVAL. The user must be alerted that the chain with 
the given name does not exist.
 
> What would you like? Comprehensive error numbers (sort of like the
> ones Windows is said to use) aka. NFXTE_NO_CHAIN_NAME_GIVEN,
> or a human-readable string; or something else?

Yes, use comprehensive error codes. And it's the responsibility of the 
userspace tool to translate them to proper error messages.
 
> >Say, the TCPMSS target should be able to report back that it cannot be 
> >used outside of FORWARD, OUTPUT and POSTROUTING.
> 
> NFXTE_HOOKMASK_NOT_ADHERED or string?

The former, i.e. error code.
 
> >Or that the rule must match TCP SYN packets.
> 
> TCPMSS doing a rule-search for -p tcp is pretty ugly (it must understand
> the data structures, and that is sort of a backwards shot); Patrick
> once suggested IIRC that TCPMSS should just silently skip non-SYNs.

For the clarity of the rules I'd prefer the current solution, i.e. check 
and enforce that the rule matches TCP SYN packets. If we relax it, next 
time someone could complain why TCPMSS is restricted to FORWARD, OUTPUT, 
POSTROUTING, why can't the system simply skip the target when called at 
non-appropriate hooks.

But I just picked TCPMSS target for errors which currently expressed 
in EINVAL.
 
> Maybe both error numbers, and providing extensions with the
> possibility to send strings? It is impossible to provision error
> numbers for out-of-tree extensions, so having a way for an extension
> to return some NFXTA_ERRSTR "One of my parameters is wrong!" seems
> required at least.

I have got a three-level error coding in my mind: general, standard error 
codes (ENOMEM, EPERM, etc.), general netfilter specific ones (like 
NFXTE_HOOKMASK_NOT_ADHERED) and table/match/target specific ones.

But I do realize that it's much easier (and therefore quite tempting) to 
construct the full error message in kernel space and just send it back.
However, that'd make quite hard to support internationalization.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
