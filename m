From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH RESEND] Add element count to hash headers
Date: Wed, 11 Mar 2015 20:20:33 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503112012020.12147@blackhole.kfki.hu>
References: <1424289208-6164-1-git-send-email-emunson@akamai.com> <54F67D2E.5050003@akamai.com> <alpine.DEB.2.10.1503062148590.29108@blackhole.kfki.hu> <54FDEEE5.4020101@akamai.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josh Hunt <johunt@akamai.com>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric B Munson <emunson@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:42089 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751538AbbCKTSp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2015 15:18:45 -0400
In-Reply-To: <54FDEEE5.4020101@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 9 Mar 2015, Eric B Munson wrote:

> > The new line in the output "breaks" any script which parses the
> > listing and not prepared that such change may occur (actually, the
> > testsuite itself must be fixed therefore too). At the same time I
> > don't really like the idea of a new flag to turn on the printing of
> > the info - just print it.
> 
> I will make sure that V2 includes any necessary changes to the test suite.

Thanks in advance.

> > The listing becomes non-uniform and type-dependent, because it's 
> > restricted to the hash types. But therefore should we add the
> > listing of the number of elements to the bitmap and list types too?
> > For the hash types, the data comes free - for the other types is
> > must be calculated at every listing.
> 
> This is the reason I only added it for the hash type.  I don't have
> any objection to adding it to the bitmap and list types as well but I
> didn't have a consumer for that information in mind to justify the
> extra calculations at run time.  Plus, the libipset consumer could
> count entries in output just as well as the library itself.

That would be a little complicated (I mean to count the entries from 
libipset): the library should cache all the entries to count them, finish 
printing the header by the element count and then print the elements.

But "ipset" supports the terse list mode when just the header is listed, 
without the elements. So I believe it's just better to calculate the 
element count in the kernel header function for the bitmap and list types 
as well. It can be a lazy counting, without taking into account the 
possible timed out entries: that way the element counter is at least 
consistent.

Let's skip bumping the revision numbers for the set types.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
