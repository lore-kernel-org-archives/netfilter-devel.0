Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C09FC41513
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Oct 2023 13:59:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbjJPN7x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:59:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232380AbjJPN7Z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2023 09:59:25 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C6E1A2
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:59:21 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-5a7c011e113so61663147b3.1
        for <netfilter-devel@vger.kernel.org>; Mon, 16 Oct 2023 06:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1697464760; x=1698069560; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wMYooUkM1nunigDk2LPCLu9Cd71nmXj5oLnseLVsCeE=;
        b=M25S8ekKZN1zkCWl21jOhJMZ3yVzn+vGx9SuKLmCmENETbSVi9Lh291KIL70j4vgdl
         O7J61ekscOPKWikwu9MVHBCheYXpFK2zH9TKDtN4pjAkNLWJEjHsm0Fq5mlrbpztjPG1
         GcVGGhlfsAFmlEzXE8/cAZ/QBiIZtPBKF30w6w5AUVtou8vGJGPSLU7H/odhmp/8LAQ4
         WpMZ6fs22m3+kb8tSGgAruwnyPq0KRHCrd3physBJstTep1MlOqv3wJrjmFtBBl6hQCG
         smh5jeAlVaKRCujx23u6zVTBinuYrAv/cqx3jzKpW/Nyb8uYe9yG8kGHpVqEvVX5Wtz5
         xpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464760; x=1698069560;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wMYooUkM1nunigDk2LPCLu9Cd71nmXj5oLnseLVsCeE=;
        b=Zgxr3QIlXWjSVcLy0mSvrPC9vOTiUSb4h4cGIocyQOrrRXcgPtzC33+U/+H0V+ujKw
         lhZrFysPMf5p4zCD+xFbYXOc2+ZiQRcvj8MOhOOC4W8DV5o85GpK1RZyCDd5qMOLFiIC
         C1neQhGHHzGEKj7PHpqpa6zh+S1syrIndKEpMdN6lqsVJYt/mnVIc9XntPYWiLAIBDYZ
         seKYXhh5MrlPafrHXtedu0Izt5Q6GbwqkNeNrfh8ksyKum42HjfBcYfiEARjnrdE4nPI
         Ibx1QlZnPZPWGcrDwZamHrm7mgXHPjujWDm+1soFi/Z+O7gjmICVGtWO9owTAghOY9/B
         1rRg==
X-Gm-Message-State: AOJu0YzpMNaHH+FyS1e27bazxxPNpWvqPrCd330pTdaz/hOSsss2Wmhu
        cgNO7KWrpfXg+Hm10VsHzMPrIzvW7nf8u9RFmiX/Rg==
X-Google-Smtp-Source: AGHT+IETRiV2/PhjUZyx0BRtzi0Hsmm6fxw54pLJiUINO18R8nKmJ9dy1P8nuaiL6mgLYz744QPxYMSIpJHE9XQPCro=
X-Received: by 2002:a0d:c8c3:0:b0:59b:f8da:ffdb with SMTP id
 k186-20020a0dc8c3000000b0059bf8daffdbmr37459485ywd.29.1697464760466; Mon, 16
 Oct 2023 06:59:20 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 16 Oct 2023 09:59:09 -0400
Message-ID: <CAM0EoMmBbnNfTMAa4jap71Sja51CMvRxJVUUvRTykPs4wKwQSw@mail.gmail.com>
Subject: 0x17: Schedule is now up
To:     people <people@netdevconf.info>
Cc:     Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        program-committee@netdevconf.info,
        Ricardo Coelho <ricardocoelho@expertisesolutions.com.br>,
        Lael Santos <lael.santos@expertisesolutions.com.br>,
        lwn@lwn.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, lartc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apologies for the delay in posting the schedule. Here it is:
https://netdevconf.info/0x17/pages/schedule.html

Amazing sessions as always.

cheers,
jamal
