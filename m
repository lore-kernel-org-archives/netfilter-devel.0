From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Mon, 16 Mar 2015 20:30:02 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503162026490.23975@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:45055 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754207AbbCPT2M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 15:28:12 -0400
In-Reply-To: <2984705.dCFJb2qqrb@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Sergey,

On Mon, 16 Mar 2015, Sergey Popovich wrote:

> I have a lot of changes to the kernel code of ipset subsystem for current
> nf-next (and upstream kernel therefore) split into the following major
> categories in order I wish to supply them to the upstream.
> 
>   * Bugfixes
>       There is not too much, but exists in upstream, few of which is stability
>       critical.
> 
>   * Code cleanups
>       Changes to make code more readable, and other things.
> 
>   * Improvements to the ipset core set/type/variant 
>     registration/deregistration and other parts of the core.
>      
>   * Improvements for bitmap:* set types where two variants implemented:
>     one for set without extensions and another for set with extensions.
> 
>   * Improvements for hash:*, where hash buckets still stores array
>     of set elements, but all element iterations is done via bitmap using
>     ffs()/ffz(). There is no error prone memcpy() of elements within bucket.
> 
>   * Improvements for list:set, where main change is to move to the
>     standard linux linked lists implementation.
> 
>   * Improve counters extension implementation to move from
>     atomic64_t variables used to store statistics to per-CPU variables.
> 
> All of these changes are made with primary goal in mind: prepare
> code for conversion from read/write locking to the RCU.
> 
> Currently my patch series consists of nearly 170 patches. I wish to
> supply each of them divided into categories I described above.
> 
> I choose to send patches against current nf-next instead of
> ipset upstream as last one seems already constains some attempts
> to implement RCU in the ipset. On this mailing list I found discussion
> about some weakness in proposed RCU implementation.
> 
> I think my implementation after all code prepare is ready for review.
> 
> All commits contains meaningful descriptions (I hope) and code
> is well commented where it is really necessary.
> 
> Main development is done for 3.2.x series of kernel, and adopted
> to the current upstream (actually cosmetics changes to apply patches).
> 
> As userspace ipset 6.23 utility is used and all changes does not
> include any kernel<->user space API/ABI breaks.
> 
> Tests are performed on both 32/64 bit arches with kernel compiled
> for debugging running ipset regression test suite. Only i386/x86_64 
> architectures are used for tests.
> 
> Thanks for your patience for reading this, please take time to review
> and possibly accept my work.

Please rebase your patches against the ipset git tree: the development 
happens there and patches are submitted from the ipset git tree to 
nf-next. Also, do not forget to create numbered patches in the future. 
Thanks!

I'm able to apply one single patch from your current series.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
