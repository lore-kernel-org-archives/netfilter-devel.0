From: =?iso-8859-1?q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Subject: Re: [PATCH conntrack 1/2] Revert "conntrack: fix expectation entry
 creation"
Date: Wed, 20 Jan 2016 20:30:31 +0000
Message-ID: <1453321831.11716.2@x201s.roaming.asbjorn.biz>
References: <20160120140955.GA441@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-xPuETCsoiit5N+xCMYU8"
Cc: pfeiffer.szilard@balabit.hu, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:32855 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754815AbcATWbT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 17:31:19 -0500
In-Reply-To: <20160120140955.GA441@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=-xPuETCsoiit5N+xCMYU8
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

On Wed, 20 Jan 2016 15:09:55 +0100, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Jan 15, 2016 at 07:47:43PM +0000, Asbjørn Sloth Tønnesen wrote:
> > {} is mask-src and mask-dst, [] is tuple-src and tuple-dst
> > mask-* should be stored in mask, tuple-* should be stored in exptuple.
> 
> Applied, thanks for fixing up this.
> 
> BTW, we have better tests under:
> 
> conntrack-tools/tests/conntrack/testsuite

I know they just don't have any expectation tests yet.
They properly should be ported. How is the policy
on adding module requirements to the tests?
I.e. `test.sh create-expect` has a comment about requiring
thr ip_conntrack_ftp module.

> I remember you also posted patches for:
> 
> http://patchwork.ozlabs.org/patch/428341/
> http://patchwork.ozlabs.org/patch/428343/
> http://patchwork.ozlabs.org/patch/428342/
> 
> It would be great if you can follow up on this, IIRC the only changed
> I asked for is that it would be good to have test for this new
> feature.

I rebased it last summer, and then again last week, I just had
to get these patches in first, since I re-use the mask arguments.
I will post it in two patchsets, first cleanup and netmask support,
and then CIDR support.

> This has been in my TODO list for a while and I didn't find the time
> to make it myself.

Mine too.

-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541

--=-xPuETCsoiit5N+xCMYU8--
