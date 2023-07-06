Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F6BEB64D9
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 09:02:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjGFJCf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjGFJCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 05:02:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292EF1BCC
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 02:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688634109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qi7u0r6BcPK/thgcy9NPn79CF3hPv/q0g1w/o2j+xHE=;
        b=iEc4p4Edj6EaaJSBaDglr3FBzHGf9rBR9fSEbBzL8CbZX2Gxqjisdov/8XA4gpCFAhRew2
        vT4qPFYCKU1vBVV2ZdcjYItqVUYmcupkE46BKtsLuuxUYDTQ64YgUqfPo3JD+0vmPRbRO0
        wpqQc2iR9eUgDsUz1/8SJ7dUScsZspw=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-9b5R9NJ-NRW23NnuGsSOcQ-1; Thu, 06 Jul 2023 05:01:48 -0400
X-MC-Unique: 9b5R9NJ-NRW23NnuGsSOcQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-635e2618aaeso1343506d6.0
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jul 2023 02:01:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688634107; x=1691226107;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qi7u0r6BcPK/thgcy9NPn79CF3hPv/q0g1w/o2j+xHE=;
        b=PGnzIPE4pcHIlME51ZK1vgLIkjXBI+oRbTmLGWBJiQgskVaG3RixWLpdSAM/sH7J5e
         4Ok35Ow4kwsP8oJrG+rzJQC/Qc95+L/Nr21BSMusdMsfxE+u+YzmE842yZ8EbVupM5Kl
         rci0w3E8iffhQJRC9Sg35RMzxdbR1WQRscpfjTfw8Orcpos+W/gmn6JJUd4DwnNcZ7nP
         YVQi4ZHmNuEXf4kzRobFFMZ7Hvp9beMB5XMf8jEwKk0yAYaRahDBMDnAeK+XyG3A4TA5
         BPtnCyt2L77cXg2G9nr5/u3p5beSuK5rkn2Y9uJfvqD8wlRssDImzfeG1R7YSamDBOtc
         9pFA==
X-Gm-Message-State: ABy/qLbK0ZM5nbiaZWVJX5k52NtOsOgPpL5upL7ysckLD5hAmi/mdiM2
        TUlbsMd0qczuxI3AlBLFm8S14cK96jPK5p+joqBzOKDPjeNLyIjzfOFs0ztIPA/+ZDDAqgB5d/n
        F3HdfXzAJERrTC6i3SCC7zVnGeo8B0vkuVRoN
X-Received: by 2002:a05:6214:5298:b0:635:ec47:bfa4 with SMTP id kj24-20020a056214529800b00635ec47bfa4mr1161161qvb.4.1688634107646;
        Thu, 06 Jul 2023 02:01:47 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGtWnu41mn5Ponn3JjXVBuIzv07N/hyizwAr6C422tUw/GBlo7Epua+9aJP5n1D7Em8tWJ66A==
X-Received: by 2002:a05:6214:5298:b0:635:ec47:bfa4 with SMTP id kj24-20020a056214529800b00635ec47bfa4mr1161142qvb.4.1688634107320;
        Thu, 06 Jul 2023 02:01:47 -0700 (PDT)
Received: from gerbillo.redhat.com (host-95-248-55-118.retail.telecomitalia.it. [95.248.55.118])
        by smtp.gmail.com with ESMTPSA id f1-20020a0ccc81000000b0062ffcda34c6sm618257qvl.137.2023.07.06.02.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 02:01:46 -0700 (PDT)
Message-ID: <8c98394f6d399b4e725521f8d9fe9788f7fe3784.camel@redhat.com>
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: report use refcount
 overflow
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com
Date:   Thu, 06 Jul 2023 11:01:42 +0200
In-Reply-To: <20230705230406.52201-2-pablo@netfilter.org>
References: <20230705230406.52201-1-pablo@netfilter.org>
         <20230705230406.52201-2-pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 2023-07-06 at 01:04 +0200, Pablo Neira Ayuso wrote:
> Overflow use refcount checks are not complete.
>=20
> Add helper function to deal with object reference counter tracking.
> Report -EMFILE in case UINT_MAX is reached.
>=20
> nft_use_dec() splats in case that reference counter underflows,
> which should not ever happen.

For the records, I also once had the need for an non atomic reference
counters implementing sanity checks on underflows/overflows. I resorted
to use plain refcount_t, since the atomic op overhead was not
noticeable in my use-case.

[not blocking this series, just thinking aloud] I'm wondering if a
generic, non-atomic refcounter infra could be useful?

Cheers,

Paolo

