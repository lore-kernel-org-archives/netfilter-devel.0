From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Parameter 'size' in type list:set is ignored
Date: Wed, 15 Feb 2017 10:33:54 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1702151020570.30100@blackhole.kfki.hu>
References: <921798b7-0b87-2e15-9f6f-b33adb46c3b8@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Joshua Hunt <johunt@akamai.com>
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:50426 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751077AbdBOJeC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 04:34:02 -0500
In-Reply-To: <921798b7-0b87-2e15-9f6f-b33adb46c3b8@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 14 Feb 2017, Vishwanath Pai wrote:

> I noticed that in recent versions of ipset the parameter 'size' in set 
> type list:set is ignored. I noticed this change in the latest upstream 
> code. In kernel 4.1 'ipset add' errors out when I try to add more 
> elements than 'size' but in 4.10 it does not. For example, if the size 
> is set to 4 and I try to add a fifth element to the set: in 4.1 it 
> errors out with "set is full" but if I try the same in 4.10 kernel it 
> lets me add the 5th element.

Yes, the internal storage method was rewritten from fixed sized arrays to 
linked lists.
 
> I think this change was introduced in v4.2 by the following commit:
> commit 00590fdd5be0d763631ef10e6a3e2ce8fc2d9ec3
> Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Date:   Sat Jun 13 16:56:02 2015 +0200
> 
>     netfilter: ipset: Introduce RCU locking in list type
> 
>     Standard rculist is used.
> 
>     Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Exactly.
 
> Adding more elements than 'size' does not break anything but has a 
> side-effect. For example in 4.1 kernel the command 'ipset add test e 
> before d' would replace d with e but on 4.10 kernel it will simply add e 
> to the list before d without replacing it.

Yes, it's a subtle difference - and I didn't think of it...
 
> Was this change intentional? Or should we be enforcing 'max elements' on 
> this set type? If we should enforce the limit then I can send a patch to 
> fix it. Please let me know.

The change was not intentional. Maybe the best solution was to print a 
warning that 'size' is ignored when a list type of set is defined with a 
size parameter.

It's an incompatibility which cannot be undone: even if we start to 
enforce the size parameter then the releases are still out which ignore 
that. What is your opinion? Should the limit still be reintroduced?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
