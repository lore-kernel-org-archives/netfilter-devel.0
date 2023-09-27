Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 013E5E810AD
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 09:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbjI0JFs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 05:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbjI0JFr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 05:05:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E3B97
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 02:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695805506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zpegyHhFZ54fXSacnFTQnJKbomsPOn94feNoZA7rwJc=;
        b=SsNV37l2orh4T+ntPyZO5KejEXPlVOzJcFmoWpl+95rPDp34mSr35DURzmFd1K5JT20i2g
        qhSGhLeCcwqpKWL2IFu+4wposyrg3Rc3jTAPK+T1VJA+fOkFDJwXdYhsZzVLMlxzWnicbQ
        +cP3OcoEfIpRDDJfKY/JFJZkoFrLM/U=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-FRcu22RjNdKkQeWSGEPaog-1; Wed, 27 Sep 2023 05:05:04 -0400
X-MC-Unique: FRcu22RjNdKkQeWSGEPaog-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae6afce33fso231674266b.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 02:05:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695805503; x=1696410303;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zpegyHhFZ54fXSacnFTQnJKbomsPOn94feNoZA7rwJc=;
        b=TpvlwJ+q3BphDGPXXfPye15F/6NnxfPimPPKGd+eIzZKUjZQz1QWIQJbD/G5D0sC3d
         Gqc47hGs6qHvR7qKdRIlLNVYwQPpq6pzCBvC3VnqviqHExFAmapd8C3QSUwiB8PU8kd2
         r9wc+dAYXAKrbMZH6L1aPvT9p1819inNHlxPAudYvcMgK3gJSzpdw8DIhUJG4RUXVSbL
         syutSvFXmctRcGPnl6WWGv4dCrxeoVNMmKfAhalsU0MYNnudvskj9n9qlNtrGeNJzXnq
         b+DthZbfhA6GPCDsIDZfUgWVq+QOUC48hqLTqGoMFx+tZ9/wnRHLWFCsHq6HGz+Xbf3c
         m7vg==
X-Gm-Message-State: AOJu0YyhdcJV//QTP4+dr67aSpIO5F3kj4HtRiS8Fl5jle0x5zUe2VS1
        PDNFUfIjRa/nv2TpoD2AyDXNXzwSoyzeSCHDY9ctXQFUiLuhcJRFANAM9ojrW1+IWwHL6azRyvh
        /jd7twDDL7Pe2a44CRTxajRaKJO4V9PYU31WN
X-Received: by 2002:a17:906:209d:b0:9a1:d79a:4190 with SMTP id 29-20020a170906209d00b009a1d79a4190mr1188339ejq.2.1695805503499;
        Wed, 27 Sep 2023 02:05:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG+pFiRsg2AxKRqnom/m2eUSvQtu/FBUtFgL8mOszaKlZ6kGZBtaWB/yPXKXTYkShBvS7B92w==
X-Received: by 2002:a17:906:209d:b0:9a1:d79a:4190 with SMTP id 29-20020a170906209d00b009a1d79a4190mr1188331ejq.2.1695805503210;
        Wed, 27 Sep 2023 02:05:03 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n8-20020a1709061d0800b009a19701e7b5sm9049240ejh.96.2023.09.27.02.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 02:05:02 -0700 (PDT)
Message-ID: <7b3c5574ce7cdff61b8550b581ff8d828440523e.camel@redhat.com>
Subject: Re: [PATCH nft] mergesort: avoid cloning value in expr_msort_cmp()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 11:05:01 +0200
In-Reply-To: <ZRPr1QVa268brGbA@calendula>
References: <20230927065941.1386475-1-thaller@redhat.com>
         <ZRPr1QVa268brGbA@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-09-27 at 10:46 +0200, Pablo Neira Ayuso wrote:
> Hi Thomas,
>=20
> We are in userspace, recursion is possible. Any chance to avoid the
> copy without this goto approach?

Hi Pablo,

I will drop in v2.

Thomas

