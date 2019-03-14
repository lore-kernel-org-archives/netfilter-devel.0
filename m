Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BA0EC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 18:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C29FF20811
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 18:24:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="eaQQy2ca"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfCNSYb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 14:24:31 -0400
Received: from mx1.riseup.net ([198.252.153.129]:46754 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfCNSYb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 14:24:31 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 203CA1A09C8;
        Thu, 14 Mar 2019 11:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1552587870; bh=XbcdntPQZPAX/Satc493AZBc4Dxl+LJLJGggWUPH/r8=;
        h=Date:In-Reply-To:References:Subject:To:CC:From:From;
        b=eaQQy2caKtQDlMPT7AOwL9DMDpZ2bcoIG08BS5p2/LX81XB7XcMTnk2ZCNNPAsdYv
         TsgzIsYBQlGjXQu0875a0eFI3qvUMUvbKaOGGtOLFzCAt9JW34tCv9pzIghdf3ZGXd
         luHkZrxuHKxEzyQV6VeBPmFskOv5w5fC2MQxAYXA=
X-Riseup-User-ID: EC66C304382E7B29739D274CD4611C6C56DF01F1F6915476B94A266BE6EBF04E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 441D42224F8;
        Thu, 14 Mar 2019 11:24:28 -0700 (PDT)
Date:   Thu, 14 Mar 2019 19:24:23 +0100
In-Reply-To: <20190314173454.GA19244@orbyte.nwl.cc>
References: <20190313094424.GA11433@orbyte.nwl.cc> <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net> <20190313112733.GL4851@orbyte.nwl.cc> <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net> <20190313150634.GM4851@orbyte.nwl.cc> <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net> <20190313153455.GN4851@orbyte.nwl.cc> <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net> <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net> <20190314135840.4j6b436zmaqe5akv@salvia> <20190314173454.GA19244@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
To:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>
CC:     netfilter-devel@vger.kernel.org
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Message-ID: <27D82259-F921-48E0-A718-A08E2BCCAACD@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

El 14 de marzo de 2019 18:34:54 CET, Phil Sutter <phil@nwl=2Ecc> escribi=C3=
=B3:
>Hi,
>
>On Thu, Mar 14, 2019 at 02:58:40PM +0100, Pablo Neira Ayuso wrote:
>> Hi,
>>=20
>> On Thu, Mar 14, 2019 at 12:14:23PM +0100, Fernando Fernandez Mancera
>wrote:
>> > Hi,
>> >=20
>> > I have been thinking more about this today=2E I don't know how access
>to
>> > the right-hand-side string from the kernel if it is possible=2E Sorry
>if
>> > the question is very dumb, but I may lack experience with the nft
>> > registers and RHS data of an expression=2E
>>=20
>> I think you can hide flags from json, which is what Phil suggests, I
>> mean, just infer version flags from the syntax, ie=2E if
>> "genre::version" is used, then set of the version flag=2E
>>=20
>> I think Phil is not suggesting kernel changes=2E

That makes sense to me=2E

>
>Actually I'm still in the process of understanding how all this works=2E
>What I got so far is (correct me if I'm wrong): osf expr does the
>fingerprinting and returns a string which relational expr compares to
>right-hand side=2E This new version flag defines whether osf expr adds
>the
>version to returned string or not=2E
>

Yes that is correct=2E

>Assuming the above is correct, my suggestion of making the flag option
>implicit does not quite hold, at least not without painful
>postprocessing of relational statement in userspace=2E
>
>Right now this all seems to me like enabling multiple comparisons
>within
>a single relational, i=2Ee=2E one for genre and the other for version=2E
>Nftables doesn't quite do such things=2E E=2Eg=2E matching on two TCP hea=
der
>fields requires two relationals, e=2Eg=2E 'tcp dport 22 tcp sport > 1024'=
=2E
>Internally then, these two statements may be combined into a single
>payload match if suitable=2E

I think in this case we can't do that=2E In my opinion it doesn't make sen=
se to evaluate only the version without the OS genre=2E Do you agree? Thank=
s!

>
>Applying the same logic to osf expression, we would implement 'osf name
>foo osf version 3=2E141' and add 'osf_try_merge()' routine to
>'rule_postprocess()' which tries to combine the two statements=2E
>Obviously, this is quite a bit of extra work, not sure if feasible=2E
>
>Cheers, Phil

