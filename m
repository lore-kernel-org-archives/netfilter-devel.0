Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E796ECDB474
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Oct 2023 08:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234726AbjJQIxy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Oct 2023 04:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbjJQIxw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2023 04:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF928E
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 01:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697532785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X5olE13+IgKlTC+ovz9ShTkq+m1U8pVtLuc/3qPItn8=;
        b=HCYtywYJiK/rcSrrhrYZCCQFOZ5ckR4uBpliCWQNJzB/g9sXqpv6d3fPk+iSFftUG53s1N
        8KVv6zAm8w4KBnVFOKH/Ep2DM9MQrLBs/gwsj2rdJ0wbXrXXBbaQxPBSALul22RpSjVvs8
        +qpjdcZ4wyw+37NiUwe6jKauhgO+MZI=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-KKUKj-yzOPGRdGfkKKaFLw-1; Tue, 17 Oct 2023 04:53:03 -0400
X-MC-Unique: KKUKj-yzOPGRdGfkKKaFLw-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-9bfbc393c43so37244166b.1
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Oct 2023 01:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697532782; x=1698137582;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X5olE13+IgKlTC+ovz9ShTkq+m1U8pVtLuc/3qPItn8=;
        b=PJ9LpVR4YCaR1iFZs4LgAK891DdCNGxXj+j4V7y6UeFIYBbdjnN7AWOBEFjv8nSJOi
         6OZE1cSW4nSPByj4E8zVG6RWIdekkTdAqUpyQe4PUiUtA9okqi+bJY010D4ylaD6akJ5
         vUGulJVm4lCp/PdXi9mMRdc9MnA4clL1SfLIc+vidWMb80+/u4T9rtsdJQX4OfzJNX/A
         HLCJNHjsZ/uKMmvq9u1fApIYTDrRZCGvEO97+yetuXiOdogw0M0E9pIZgBtto+Bs4/RT
         kiUY/Gc4HSF7qgZ+BvZB3POMDImgy7Y3MqviViZk67AsChYwGF7CW8DX2RPWfNGUnr0Z
         BThA==
X-Gm-Message-State: AOJu0YxHZoByuOQe0aACJLL4fAFSoMPlJ8rz0BpYZc9U+6Qhml6tPfCg
        4Yg0PQZI8YiUXZ6GNvy/r/lT6/5yK3t703wjlJbe+XFKF5noYrry2f2uhVK/4LE+K2sDmSu6DIc
        dToruPryVNQxWYQ3/DMCZuDLgIbOgeJFAfHJ4
X-Received: by 2002:a17:907:94c3:b0:9c4:409:6d42 with SMTP id dn3-20020a17090794c300b009c404096d42mr1127777ejc.3.1697532782078;
        Tue, 17 Oct 2023 01:53:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IETQkTXZwO0ipeK+O88suq8rEQ698OVQkAtimuH1maNPeJylKwIYvxxk8UDpE3T5gPbHwIHSQ==
X-Received: by 2002:a17:907:94c3:b0:9c4:409:6d42 with SMTP id dn3-20020a17090794c300b009c404096d42mr1127769ejc.3.1697532781790;
        Tue, 17 Oct 2023 01:53:01 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.64])
        by smtp.gmail.com with ESMTPSA id v5-20020a17090651c500b009b2c5363ebasm839358ejk.26.2023.10.17.01.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 01:53:01 -0700 (PDT)
Message-ID: <8ba35562342ab328e2ec3d3bdd81b58e7dacbe0c.camel@redhat.com>
Subject: Re: [PATCH nft 1/3] tests/shell: skip "table_onoff" test if kernel
 patch is missing
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 17 Oct 2023 10:53:00 +0200
In-Reply-To: <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
References: <20231016131209.1127298-1-thaller@redhat.com>
         <ZS2bKZVAN5d5dax-@strlen.de>
         <a64bccda9ab11f18f13d0512001985d1bf9f04ff.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-10-17 at 08:22 +0200, Thomas Haller wrote:
> How about "eval-exit-code"?

Hi Florian,


shown in

  [PATCH nft v2 0/3] add "eval-exit-code" and skip tests based on kernel ve=
rsion

How do you like that?


Thomas

