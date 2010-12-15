From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Wed, 15 Dec 2010 05:55:44 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Friday 2010-11-26 20:01, Jozsef Kadlecsik wrote:
>On Wed, 24 Nov 2010, Jan Engelhardt wrote:
>
>> By request of Pablo, I am posting the Xtables2 Netlink interface 
>> specification for review. Additionally, further documentation and 
>> toolchain around it is available through the temporary project page at
>> 
>> 	http://jengelh.medozas.de/projects/xtables/
>>  * Runnable userspace library (libnetfilter_xtables)
>>    with small test-and-debug program
>[...]
>
>Please add fine-grained error reporting to the protocol: in my opinion the 
>main shortcoming of the current kernel-userspace xtables protocol is the 
>lack of the proper error reporting. I mean, the new protocol should be 
>able to carry back which rule caused the error, in the rule whether it was 
>a general kind of error (ENOMEM), or a table, chain, match or target error 
>and exactly what was the error at table/chain/match/target level.

That should not be a problem. However, what do we do with the general
kind of error that is overly general? A.k.a. the dreaded EINVAL.

Say a user requested jumping to a chain, but did not give a chain name.
Normally that would be EINVAL, but EINVAL is overused already.

What would you like? Comprehensive error numbers (sort of like the
ones Windows is said to use) aka. NFXTE_NO_CHAIN_NAME_GIVEN,
or a human-readable string; or something else?

>Say, the TCPMSS target should be able to report back that it cannot be 
>used outside of FORWARD, OUTPUT and POSTROUTING.

NFXTE_HOOKMASK_NOT_ADHERED or string?

>Or that the rule must match TCP SYN packets.

TCPMSS doing a rule-search for -p tcp is pretty ugly (it must understand
the data structures, and that is sort of a backwards shot); Patrick
once suggested IIRC that TCPMSS should just silently skip non-SYNs.

Maybe both error numbers, and providing extensions with the
possibility to send strings? It is impossible to provision error
numbers for out-of-tree extensions, so having a way for an extension
to return some NFXTA_ERRSTR "One of my parameters is wrong!" seems
required at least.
