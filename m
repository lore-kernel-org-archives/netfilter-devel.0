Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D31C77B7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 12:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbjEJMDb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 08:03:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjEJMDa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 08:03:30 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225E38690
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 05:03:24 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-ba67d34350aso127959276.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 05:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1683720203; x=1686312203;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uCim+bkRSF5TeAVtzxeNUFktZnXXPuGjUTKfTMY/2Zw=;
        b=hngiIEi69KPKqZgfHKZ/ulUvZQKAnVcBbnckq1EvJ/1mSnqfuuToaM0vXAxZ7R0uTg
         Q8lUEWD0zaY+yeLkR7PgImLYRvGp66qjGiWb3q3xWdWoua7YhgIo53s3B80rcLQm+Hob
         OHkH/5CX6nmqRAk9atkUC8OmBmSZbC2rWo0u9YA76Ea+VtcUIk9yrlcGMA90zbiwbtZz
         305ZKd0sUQXlnvt7EiAfBdm/jFq0bfgOt2diaZA3ykgTyNLJfQhipLbN/Y/ekImi0grm
         hSz9a6jcUhe3Z1xjzLS94px2bQyl7ULTgJTTXMF0ameajZ8TRD9MSDbv028DAARzva2K
         WN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683720203; x=1686312203;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uCim+bkRSF5TeAVtzxeNUFktZnXXPuGjUTKfTMY/2Zw=;
        b=azheGffOjMfuCblqK/GBpWo34aVMYZg724mqSFVwziWY4jYT+FiOF9jXsGyZKzQnRU
         XK6Qj9JWiDNg3mjjBVq4LPAPwcbmmPrKZud0DMvWtkLlAA6DtWOUTxE1uAAUlQHhG3c7
         7nHc+FjN1tE/8S8x3c7IFXvsoXc6QEwnH8PxNLwPKBQYHjzmunhEJYm5emqNX5GvmMK4
         ltaW1eLSUHX0XNZ3tXpAz/lCtshXfHEndmFO5IQV724qXkgUUKkMsLGChGC/sv2RxXAy
         FWAq8wquqZZo39Jp3IbMPVOZu5puG8ryMpXCCDvEZrI/H0aIIir4AGCnHjGTJw49CBlG
         fMUg==
X-Gm-Message-State: AC+VfDy3gWH0bIFqxfYWJvyp3KeQ22euteZeWraV7jCki3NliBFe31zP
        7Ut+EIlVI8FvRF+36x5gSpcO3Bbn0bt0eYBvYlANeQ==
X-Google-Smtp-Source: ACHHUZ4DynBs8EVJ3L4HnyeLVH08l/L//dmkuGhVuP6Mi4in/UDseRJCC7BoEc8Bms3kweOiDVlhdDtglocsYXjiisE=
X-Received: by 2002:a25:2612:0:b0:b9e:3bea:ebbb with SMTP id
 m18-20020a252612000000b00b9e3beaebbbmr16897621ybm.60.1683720203247; Wed, 10
 May 2023 05:03:23 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 10 May 2023 08:03:12 -0400
Message-ID: <CAM0EoMktXKNL5YejPOuUqVW_kLudzy5t5R0MvB=H6RKzLwV8dw@mail.gmail.com>
Subject: Anouncement: Netdevconf 0x17
To:     people <people@netdevconf.info>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, lartc@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        Jeremy Carter <jeremy@jeremycarter.ca>,
        Felipe Magno de Almeida <felipe@expertise.dev>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

This is a pre-announcement on behalf of the NetDev Society so folks can plan
travel etc. Netdev conf 0x17 is going to be a hybrid conference.
We will be updating you with more details in the near future.

Date : Oct 30th to Nov 3rd
Location : Vancouver, British Columbia, Canada

Be ready to share your work with the community. CFP coming soon.

sincerely,

Netdev Society Board:
Roopa Prabhu,
Shrijeet Mukherjee,
Tom Herbert,
Jamal Hadi Salim
