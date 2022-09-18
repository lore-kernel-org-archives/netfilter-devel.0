Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBEA1ECAAD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Sep 2022 17:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiIRRua (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Sep 2022 13:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiIRRu2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Sep 2022 13:50:28 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36623101C1
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 10:50:27 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id u131so12082711oie.5
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Sep 2022 10:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=B4ku7Q0m87H005fve0gYS/APRmgvwZgKfFQOE5hZ8Wk=;
        b=7JKQ0XvacUdZIYlFxnsPQmRs4Y6OHNqLPlIEp6QPYx94A2BQeZMayryuq+4m1QYj6W
         15OsOHyPSNGjTarXPTf1KB9j1K/UpwbGnht34CyoLx3GjaXb0a/5s9Yr1T60AnAs0qKc
         RfwH2BnLovcawIs8mhrkSMryKY+jdXdFCMoVfIg9jGvmY14NR+oYqdxKwgeKYYf0NAte
         D/Dy6/wQiogRWsqhjYL66c6NBm9Z1Kgtd9x41Lx7lJRMZf2Lr6Wmj0no6vEfO6FaCX5B
         4AaHrAteU/oKeKpkdrCUihV11+3/JEWopU6W8tO3DalSLqoiFc6b1sSG9ihuWi0hrmpE
         9E1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=B4ku7Q0m87H005fve0gYS/APRmgvwZgKfFQOE5hZ8Wk=;
        b=x4nrcrvOODRo9kqbQRNPmbz1TvEZXn4WyrrVQ11YYBYTLIBxgsvSr7Kt34R6OxLlBo
         uWPEcOxsPO4aomu5E1m4hXnuFh7IGJfJEAyIybElFoI/3ycDStRII7gw1o/fUVnehZ3p
         ijvl3qtrtD4gMf+rYUZJk7fOkvtBksWzB4cg2zyZtz7dCwdGixtYV4D8o/o9DiOxKrQr
         usmb3aP/9ZW4ic8NoW7KO4KT5A6255aPrTK0KAoHF+Ie1fkBnEPkE2x5pelvDRR87rdB
         zGWX6C+ojt46IBJgLW8suwoP/dZyHjn1yRNTHhlkqPjfJN19ruVMg+3fSLTNXFRJeaon
         QgFg==
X-Gm-Message-State: ACrzQf1XJnYsXtP9JTXfhcHP5RdancRP5PICZZTSyfr3ZoTQmRB/rp+Q
        gTNQNnXIbyS8M+Z2O1yeQ+5JRd4kqltPfdbZ9lQfAkHuWOUTKw==
X-Google-Smtp-Source: AMsMyM6ijVdD5CWqQsrsikoPeFWWizTflAVGvLaqB5yE9vLd6kB2TJhb9p9pC9fwYEL2Q9sJfY1hJwfHOFbZ8VRJbP8=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr3657114oiw.106.1663523426567; Sun, 18
 Sep 2022 10:50:26 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 18 Sep 2022 13:50:15 -0400
Message-ID: <CAM0EoMkysUg4kaK7ED5HF-uGypB734uzw3nmfdpkvM6+Q7g1GA@mail.gmail.com>
Subject: ox16: First Workshop, Mini Netfilter workshop
To:     people <people@netdevconf.info>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        prog-committee-0x16@netdevconf.info
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso will chair the mini netfilter workshop that
will cover updates in Netfilter land since 0x15.

cheers,
jamal
