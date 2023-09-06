Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22373EB8FA5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 05:18:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjIFFSg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 01:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjIFFSg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 01:18:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05097CE2
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 22:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693977452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Pdzj/jIrFOv1Et5llHhkfZiBjrO2YbMKb1Pl/fuoryk=;
        b=dog2zITeZRP+gcKMEyE3I70/paw3heRm1zllSrA3EKkBPvPpMuWAS+BduMzHPDioUKQPF5
        m89XmXp4kuPLRT9WNehZq+DYuhL4scPZbqV2x5IzetKCgT5iyFCcAbG+Y64gzpsTLC0b/7
        O6VKG1rW0QSsWE3v8xhnbMcIWISok50=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-vVojtuttP5OOenGdPChC8w-1; Wed, 06 Sep 2023 01:17:31 -0400
X-MC-Unique: vVojtuttP5OOenGdPChC8w-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-319553c466dso279235f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Sep 2023 22:17:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693977449; x=1694582249;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pdzj/jIrFOv1Et5llHhkfZiBjrO2YbMKb1Pl/fuoryk=;
        b=JBMjsLMOSx3n2UyZFUDnk6dMhOm0uwLpAtO7Spu7vnGq/6XeDALSGMCsiuBAsWiZB9
         qliHxwe6KOeRLZLVO/STU4erI/AmGa3KpSGmZVEz1CsN1RZmzl6KZigPXl9wkPhryac7
         fkpYdgK1Ab+jDOi/VgHK5xBw4WgVCO5KXRin36kS9PQELSgKt081PsprkCPHP2Rdoxdy
         SjfUOSO/lSZnHAIBMRg/kDZqp3E2PVWEaPSlWJZpWnHdI5CP31efAH1RChZa3N9z61JH
         MzaZvXOXwLoVWqJS5LI3nwIc3M4afqUeFc5t6tMzTr0zf2adisGkqrNBdDxCuuMhzrzV
         +cdw==
X-Gm-Message-State: AOJu0YxM2CDBhmatdR8dHBLol5uw2tmBCZEnQHP2wXc8hqxu6AQHwaYN
        IgkzSMFB79iUQjcJTM7bmMx9L0ncAuHE0Btay7Lthrvtbm9ldl2XSXKB8ULzqYa4zVjmIdZIiE2
        7Hj9cxY/WmKuxhsXRsnv6t468gdaDqhne22gn
X-Received: by 2002:adf:e252:0:b0:317:3da0:7606 with SMTP id bl18-20020adfe252000000b003173da07606mr10611748wrb.4.1693977449678;
        Tue, 05 Sep 2023 22:17:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0dRKKzVDMC7JO0zWc9kMS5T0ytvXnMbn9QA8kOI9UQjCV/Q7YSizouGpvrkWbrZG3UlwUUQ==
X-Received: by 2002:adf:e252:0:b0:317:3da0:7606 with SMTP id bl18-20020adfe252000000b003173da07606mr10611739wrb.4.1693977449399;
        Tue, 05 Sep 2023 22:17:29 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d4084000000b00317b0155502sm19277482wrp.8.2023.09.05.22.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 22:17:28 -0700 (PDT)
Message-ID: <551da7716e5e3a59f85db9e0b78e9eec55c33bbe.camel@redhat.com>
Subject: Re: [PATCH nft 1/5] tests: add feature probing
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 07:17:27 +0200
In-Reply-To: <ZPcmZ4nqfG43SuM9@orbyte.nwl.cc>
References: <20230904090640.3015-1-fw@strlen.de>
         <20230904090640.3015-2-fw@strlen.de> <ZPcmZ4nqfG43SuM9@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-09-05 at 15:00 +0200, Phil Sutter wrote:
> On Mon, Sep 04, 2023 at 11:06:30AM +0200, Florian Westphal wrote:
> > Running selftests on older kernels makes some of them fail very
> > early
> > because some tests use features that are not available on older
> > kernels, e.g. -stable releases.
> >=20
> > Known examples:
> > - inner header matching
> > - anonymous chains
> > - elem delete from packet path
> >=20
> > Also, some test cases might fail because a feature isn't
> > compiled in, such as netdev chains for example.
> >=20
> > This adds a feature-probing to the shell tests.
> >=20
> > Simply drop a 'nft -f' compatible file with a .nft suffix into
> > tests/shell/features.
> >=20
> > run-tests.sh will load it via --check and will add
> >=20
> > NFT_TESTS_HAVE_${filename}=3D$?
>=20
> Maybe make this:
>=20
> > truefalse=3D(true false)
> > NFT_TESTS_HAVE_${filename}=3D${truefalse[$?]}
>=20
> [...]
>=20
> > [ $NFT_HAVE_chain_binding -eq 1 ] && test_chain_binding
>=20
> So this becomes:
>=20
> > $NFT_HAVE_chain_binding && test_chain_binding
>=20
> Use of true/false appears to work in dash, so might be POSIX sh
> compatible?
>=20
> Cheers, Phil
>=20


That's possible. But I would not do such non-obvious magic.

The existing variables like VERBOSE,VALGRIND,DUMPGEN use "y" for true
and everything else is false. I'd stick with that form.

The form would be (exactly):

if [ "$NFT_TESTS_HAVE_chain_binding" =3D y ] ; then


Btw, as a matter of principle, I think that all variables in the patch
set should be quoted.


Thomas

