From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH RESEND] Add element count to bitmap and hash headers
Date: Tue, 17 Feb 2015 22:35:40 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1502172223580.16817@blackhole.kfki.hu>
References: <1424187335-5968-1-git-send-email-emunson@akamai.com> <20150217155331.GA3341@salvia>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric B Munson <emunson@akamai.com>,
	netfilter-devel@vger.kernel.org, johunt@akamai.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:56392 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbbBQVeE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 16:34:04 -0500
In-Reply-To: <20150217155331.GA3341@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Feb 2015, Pablo Neira Ayuso wrote:

> On Tue, Feb 17, 2015 at 10:35:35AM -0500, Eric B Munson wrote:
> > It would be useful for userspace to query the size of an ipset.  This
> > data is held for both the bitmask and hash types, however, it is not
> > exposed to userspace.  This patch uses the otherwise unused attribute
> > IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
> > exported to userspace.
> 
> Thanks for your patch.
> 
> I think Jozsef will need the userspace bits for his library and
> utility.

Yes, that's missing from the patch. Also, I don't like any change which 
affects the userspace but not expressed in new set type revision. Later on 
the new revision makes much simpler to identify why the "Elements: is 
missing from the listing of a set.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
