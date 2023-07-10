Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C13DEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Jul 2023 10:24:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbjGJKYe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Jul 2023 06:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjGJKYd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2023 06:24:33 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEF494
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 03:24:31 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3fbc77e76abso45162105e9.1
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Jul 2023 03:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1688984668; x=1691576668;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6cRtBGl2Jd1fZvryX9XkjpF1gAXAlryMpWJLazKFVjI=;
        b=X4DS7UynebrTJVoaLCWi34C2KFcljiicvoAdlMxJT2icAMBTv8+436wBbgEcmL4vQz
         oCO0Ll7lSOswr7ix+SyzTxWy2h0Keubes4cuNUQ7L3nJ6iQo9pTweuGARhbYVMZKkha2
         pat2F06Gp2SsANs8SONYRmZXEf5fAlq31XSfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688984668; x=1691576668;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6cRtBGl2Jd1fZvryX9XkjpF1gAXAlryMpWJLazKFVjI=;
        b=V1NDKocKnMLAZBOSPa2w5gE0Gv93UaBrGjjJyNAAqB01FHGVkMb7wZT9RgF/jVulI6
         ak1nptxnTsdZxsiCatL+mGCtJTUaNrOSgYvGlz5hH+PtR2FdGEd6PMyPC4AE1sJF4bYQ
         ankJP/lIOLJfCK0L7m2Qr1Vu5WXymueSPcv9ars/lSiOzbaVtUTgkqLCSp+Otb8oSVRL
         du6uWfnw5Yg1DXvAhpi2wVtwH0F9XEAE5PJwKbVp09xD0bpm8IzS7eXpH7KBOMrCxnKj
         7aJI0x4nEX263n2rQwORh0WByPMf+uhS4is7axxMdgCkOrVySBtgbhtf9E0Jh5C91x2B
         KAlw==
X-Gm-Message-State: ABy/qLYaaaxsVeeaPRdrjqp0UguzXNRvet4IHoF4iyg4ScQGz+I7K4Qr
        MFfQot+F9DW2kDrAP6WxxF/VocZTyiWRCN3PycLmYOnH64qerzllAKU=
X-Google-Smtp-Source: APBJJlEzrjahu6hPGchrl8vN+fympQ1Z+FsBQ/pvfT9nGT1KLynwxnHBOS+0ucXJb7NNFFFxWPY0yxhUYl8lY62dNLo=
X-Received: by 2002:a05:600c:21d4:b0:3fb:ad5d:9568 with SMTP id
 x20-20020a05600c21d400b003fbad5d9568mr10754047wmj.38.1688984668668; Mon, 10
 Jul 2023 03:24:28 -0700 (PDT)
MIME-Version: 1.0
From:   Igor Raits <igor@gooddata.com>
Date:   Mon, 10 Jul 2023 12:24:17 +0200
Message-ID: <CA+9S74jbOefRzu1YxUrXC7gbYY8xDKH6QNJBuAQoNnnLODxWrg@mail.gmail.com>
Subject: ebtables-nft can't delete complex rules by specifying complete rule
 with kernel 6.3+
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

We started to observe the issue regarding ebtables-nft and how it
can't wipe rules when specifying full rule. Removing the rule by index
works fine, though. Also with kernel 6.1.y it works completely fine.

I've started with 1.8.8 provided in CentOS Stream 9, then tried the
latest git version and all behave exactly the same. See the behavior
below. As you can see, simple DROP works, but more complex one do not.

As bugzilla requires some special sign-up procedure, apologize for
reporting it directly here in the ML.

# ebtables -L
Bridge table: filter

Bridge chain: INPUT, entries: 0, policy: ACCEPT

Bridge chain: FORWARD, entries: 0, policy: ACCEPT

Bridge chain: OUTPUT, entries: 0, policy: ACCEPT
# ebtables -t nat -N barani
# ebtables -t nat -A barani -i br_public --among-src fa:16:3e:26:bf:42 -j RETURN
# ebtables -t nat -D barani -i br_public --among-src fa:16:3e:26:bf:42 -j RETURN
ebtables v1.8.9 (nf_tables):  RULE_DELETE failed (Invalid argument):
rule in chain barani
# ebtables -t nat -A barani -j DROP
# ebtables -t nat -D barani -j DROP
# ebtables -t nat -L barani
Bridge table: nat

Bridge chain: barani, entries: 1, policy: RETURN
-i br_public --among-src fa:16:3e:26:bf:42 -j RETURN
# ebtables -t nat -D barani 1
# ebtables -t nat -L barani
Bridge table: nat

Bridge chain: barani, entries: 0, policy: RETURN
