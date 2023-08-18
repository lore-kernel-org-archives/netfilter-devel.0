Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF3E2C001DE
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 09:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359331AbjHRJqI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 05:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359333AbjHRJpp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 05:45:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258062684
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692351907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YhAOOpjdRwHeH7uSTgcK9qACYuSm34SyzRzvzpIPz/U=;
        b=P5OFk84vBs8UtxdVCB/ZBgfB0EGROcVu8t9Pduim0Mwa2nnKzAenWg/S3ouOgHE+wyOfgk
        wdAV5Rv4R8YfYf2MBsZKk8kKso9eNmYSwLYJDkqcV1P7XcZCZK6KGgIQnZTpnhvL1Y1LDl
        ClJYBg/rSLvGEZxcRQq2UU9BFsyMOJg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-XMblsx1GOrmDeq97s5LA3Q-1; Fri, 18 Aug 2023 05:45:05 -0400
X-MC-Unique: XMblsx1GOrmDeq97s5LA3Q-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3fe14dc8d7aso1736845e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 02:45:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692351904; x=1692956704;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YhAOOpjdRwHeH7uSTgcK9qACYuSm34SyzRzvzpIPz/U=;
        b=QsTNR0hXzeXQadi3a3aLaGX5bmCCpKR6GSvSjyPpBBXjAm+McG3avcNBnz+JkiWkmM
         dr4QSHSHexl+yy6diyHKbSinbWGSA78SKBlCEtR6B7/zare01Lx29gXLRJXXQt2lWzxp
         f5r8q8bnUm5Isox1pZ5zuw0VdUEtLFk6s9/7yJRsdMoOKQiMdHWqiBj7x1jkEkgpaItK
         GUyIEw81ouc5TEILOqqaZztz7G56wy0hdVp394LLNoF21J6F1/HMufuA43iptwHzdfZG
         A6AX5iV6lsjcdUSWKm1dckDf+/KKumaOie+vmtV9Y2WKyuv5975QH90HTEaYQXFDiN1d
         aV4A==
X-Gm-Message-State: AOJu0Yxuq1dmiTGFl7bm423pauboEIELAXO6WoZKEzlIlDrcsQZXQDIW
        GLiBinXWLqoc5ciN8nu3LsI1eK7xgQRE6Y7AfSQtPtOlNBPhbYznt6UpmTAMdio/R5170+u8TQ5
        WwgxJh6niUOxvCNY3fB6xgwoPMeCUmO82pLjK
X-Received: by 2002:a05:600c:1c1b:b0:3fc:2d8:b1f2 with SMTP id j27-20020a05600c1c1b00b003fc02d8b1f2mr1762438wms.3.1692351903947;
        Fri, 18 Aug 2023 02:45:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHptfQGCtu+dz6e6PrA6WvR6yEduoVazwvJKo/3S+kmVo3x2I5GqfIf5CduNmiqr4VAG9v1pQ==
X-Received: by 2002:a05:600c:1c1b:b0:3fc:2d8:b1f2 with SMTP id j27-20020a05600c1c1b00b003fc02d8b1f2mr1762423wms.3.1692351903608;
        Fri, 18 Aug 2023 02:45:03 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id v26-20020a05600c215a00b003fbb618f7adsm2248973wml.15.2023.08.18.02.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 02:45:03 -0700 (PDT)
Message-ID: <83178df199548eef789707dcedd6783d7307cc91.camel@redhat.com>
Subject: Re: [nft PATCH v4 2/6] src: add input flag NFT_CTX_INPUT_NO_DNS to
 avoid blocking
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 18 Aug 2023 11:45:02 +0200
In-Reply-To: <ZNzy9+OPzBiYVnvT@orbyte.nwl.cc>
References: <20230803193940.1105287-1-thaller@redhat.com>
         <20230803193940.1105287-5-thaller@redhat.com>
         <ZNJCFNlZ8bHuJOkl@orbyte.nwl.cc>
         <e095b0fe0c6db0eaafb8072abfa5102a55f9df41.camel@redhat.com>
         <ZNNoUHB/i7rxPXS1@orbyte.nwl.cc>
         <b1829e8f312b2e626dc4efefdc1d666044405552.camel@redhat.com>
         <ZNSVo9Um6T0fgqXA@orbyte.nwl.cc>
         <7f3848f6d52a2521df8bd1ee01b2fdb0af9b57a1.camel@redhat.com>
         <ZNzy9+OPzBiYVnvT@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-08-16 at 18:01 +0200, Phil Sutter wrote:
> > >=20
> > > I'm pretty sure it does, albeit maybe not officially.
> >=20
> > That would be important to verify. I will check, thank you.
>=20
> Did you find time for it already?

Hi Phil,


Not yet. Will do.

Note that the new behavior is opt-in, and firewalld will have to change
to get it.


Thomas

