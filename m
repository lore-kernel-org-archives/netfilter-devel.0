Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71619C71153
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Aug 2023 18:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbjH2S5Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Aug 2023 14:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbjH2S4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Aug 2023 14:56:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3515CCC5
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693335358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hTTXlMzFAWdZXNfhqvbjVh2p6KfgpwnVtvVFYwnMD1M=;
        b=FtfgyaUMI8i7tSfGHawfDX9DM3LJfJn09DG1dn10WPOBODJTq/mfdwzRz/HTLgb2F9tQnR
        PifhOMvu4oQ8F9Ydj1uSKyBdWdSvfJX2OicnHYUwzF79JLcAq05+RUbMCmYQAtsFo6Bp/6
        gBt20u276LSQNsv4G+rMDxWp9R8glbs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-P8LSSVzOP5udMmK13-KhEg-1; Tue, 29 Aug 2023 14:55:56 -0400
X-MC-Unique: P8LSSVzOP5udMmK13-KhEg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-31799700ed4so1038249f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Aug 2023 11:55:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693335354; x=1693940154;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hTTXlMzFAWdZXNfhqvbjVh2p6KfgpwnVtvVFYwnMD1M=;
        b=gGxW+rhvoqBHg5Je8mQcu10UX0pD8FBcr0geIhaB9v3RyWE0aKUp3zjbijQRBwh/+q
         NdfViPKHAcbPgyoMNRydG8Yw4dJgSFmaKgXqfCUAFY0C7Mar0xOjbqsgcyFK0gb5IHG0
         CfM/zWfFhDmXab9LJx1YTSbA1Yd6YmxWvbn7DIcUkO3NIN7XgEQCNEXrdgfn/Xa70ctb
         Uqi/EOmbMHSObf/GX8teZrCrg2+ipPrCbm5+pVl9VObTh3AkZcJCvM4lk65TJqpPMk7l
         u+xiIxo1cw1R9I30aijOptPsMv3rU5xH2gzuiZ1jJSdAZpbQe2srKp625Y0e5ajQpCPF
         zAVQ==
X-Gm-Message-State: AOJu0YztzxbkakDvQK2tUXNTwaSFJq4qB7d3bdRcNw7v2VUtvsEpzM+x
        mqX68fitjrjBadub//vt0emUyBMckwKtLAMigNO606uO2F+uaxZw7CsEPRIEku151E2Mp1F8YbQ
        rjfOTUsxQVqrdr+/8WqcsbpkEpa571X2WiOZ+
X-Received: by 2002:a5d:4403:0:b0:317:8fd:f01a with SMTP id z3-20020a5d4403000000b0031708fdf01amr20061307wrq.7.1693335354810;
        Tue, 29 Aug 2023 11:55:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHcSgNgCeCd6iFmIwbRJDlcG3VjqqgFXsiuBnfE0JdM68yCj7OHzhjnxEb1Qt92QHDcEyo7Bg==
X-Received: by 2002:a5d:4403:0:b0:317:8fd:f01a with SMTP id z3-20020a5d4403000000b0031708fdf01amr20061296wrq.7.1693335354496;
        Tue, 29 Aug 2023 11:55:54 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id e8-20020a5d5948000000b003143add4396sm14511939wri.22.2023.08.29.11.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 11:55:53 -0700 (PDT)
Message-ID: <09f9860d8a4f5b88339e3c244bc95b82788f6ed6.camel@redhat.com>
Subject: Re: [PATCH nft v2 6/8] evaluate: don't needlessly clear full string
 buffer in stmt_evaluate_log_prefix()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 29 Aug 2023 20:55:53 +0200
In-Reply-To: <ZO40H1KvHY+DIZTW@calendula>
References: <20230829125809.232318-1-thaller@redhat.com>
         <20230829125809.232318-7-thaller@redhat.com> <ZO40H1KvHY+DIZTW@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 2023-08-29 at 20:08 +0200, Pablo Neira Ayuso wrote:
> Please, always add description to your next patches, in this case a
> long description does not make sense, but probably there is something
> else it can be said on top of the patch subject.
>=20
> Thanks.
>=20

ACK!
Thomas

