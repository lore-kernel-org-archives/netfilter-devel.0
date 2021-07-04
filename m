Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31584C07E95
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 23:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CE9261352
	for <netfilter-devel@archiver.kernel.org>; Sun,  4 Jul 2021 23:46:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhGDXso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 4 Jul 2021 19:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhGDXsn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 4 Jul 2021 19:48:43 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1684FC061574
        for <netfilter-devel@vger.kernel.org>; Sun,  4 Jul 2021 16:46:08 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id mn20-20020a17090b1894b02901707fc074e8so10490277pjb.0
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Jul 2021 16:46:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :mime-version:content-disposition;
        bh=cL9FPazmk8PZSPO7rmpPfXdYSWrtyzaQkm8UpQ/izPg=;
        b=fXhRSRC2Qs838qHI+jKqnOK4Mkz3pCnOtSwjh69BEdStxfR5jxdJ9DvzAnDSANOqD6
         DJsBfuKIIFVTyEveilVUvIcHvPknY/aG1j0XdPEeGZ3/Em1iavOrM0SxCOg82IM5SBWn
         vTY2Uy6eu3WWeOdQpdeudfxBl0z25egnrvFKNO2Qj76pIrEVh6DDG3+48Lp0ZwU3FTv8
         qamFIzHuj2fWkwzVrUz6Xqa1wd++otxjBUEx6Fi42aNgDhaQLI2Wn8Vc5Q5qXfcnsrSI
         Xztn6/UYlAU0B/F2yIt+raYpz8WEufy/f2UwXDvVBQyxS+RCEdQ2O1Hyc7aWHSBIe4KF
         gwSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:mime-version:content-disposition;
        bh=cL9FPazmk8PZSPO7rmpPfXdYSWrtyzaQkm8UpQ/izPg=;
        b=Hl9BHe7wsSGFsfCW8o+xuyeRuDIIq7C2mk7PPoQ8z0LsF9uDjoA9iECRNSYZC7uYVp
         VNLT39CtHaL7ijKI+8J0HP0hTm2QG4ld/IdI02K6t2NPI0auDxwXqVMREWORoTlF51pa
         vsth2FmjQ8cTuTnJiLJSKDb1fDNlYmZknULAI7SrusH3SMGj5IzNm8JwjhG6uGzhowX7
         v3Mk1OwhGsXhXM9cV6IHuSSElykNSBkM+wAugWv/Bs7xPshzHKrm8C0m8SEuGIZ5MbKQ
         AGN4wIO6HJqcqaZQJPFShjUQkEGFKZ8Rof0EhClSrU6ggEpkWQyDJWSTMGQgYFK2ZCpF
         9oNA==
X-Gm-Message-State: AOAM530aGtnzY92NlkozC3EgVIWEtg/9DGxfQus4vOMPfpuecKmK1WOn
        +KinPOTs/WeHOS4TEmSb8n3fdph28gM=
X-Google-Smtp-Source: ABdhPJzbTzVvBcsw91PsYNejSkbbl0aOQYS4zdbXLESx10avE5EhVCAuD7z2ciedSUmEC9XWPH/Gkw==
X-Received: by 2002:a17:902:6805:b029:129:6018:fedd with SMTP id h5-20020a1709026805b02901296018feddmr8245647plk.26.1625442361617;
        Sun, 04 Jul 2021 16:46:01 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id n33sm11609803pgm.55.2021.07.04.16.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Jul 2021 16:46:00 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk1.local.net>
Date:   Mon, 5 Jul 2021 09:45:56 +1000
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Documentation question
Message-ID: <YOJINLIUz9fFAxa2@slk1.local.net>
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Did you follow the email thread
https://www.spinics.net/lists/netfilter/msg60278.html?

In summary, OP asked:
> Good morning! I am using the nf-queue.c example from
> libnetfilter_queue repo. In the queue_cb() function, I am trying to
> get the conntrack info but this condition is always false.
>
> if(attr[NFQA_CT])
>
> I can see the flow in conntrack -L output. Anyone know what I am
> missing? Appreciate your help!

and Florian replied:
> IIRC you need to set NFQA_CFG_F_CONNTRACK in NFQA_CFG_FLAGS when setting
> up the queue.  The example only sets F_GSO, so no conntrack info is
> added.

My question is, where should all this have been documented?

`man nfq_set_queue_flags` documents NFQA_CFG_F_CONNTRACK, but
nfq_set_queue_flags() is deprecated and OP was not using it.

The modern approach is to code
> mnl_attr_put_u32(nlh, NFQA_CFG_MASK, htonl(NFQA_CFG_F_GSO));

NFQA_CFG_MASK is supplied by a libnetfilter_queue header, while
mnl_attr_put_u32() is a libmnl function. What to do?

Cheers ... Duncan.
