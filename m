Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4BF9C07E9B
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jul 2021 10:12:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFA586113A
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jul 2021 10:12:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235905AbhGSJcM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jul 2021 05:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235609AbhGSJcM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jul 2021 05:32:12 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3F0C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jul 2021 02:17:51 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id my10so11094462pjb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jul 2021 03:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YBz2gLPjZvoutWGqZI+M3AwJew3pzLAmArebHkk7mtg=;
        b=cdZqXLbcqqBf0u1YtFUnapzu6l4TxdutbrFVV6I2FbskYmhjABz8ul0UzGDnXsW6pl
         KXSpJH1Q/U+WOsMzfCBtvBDeDVMlL//InbUzrqyBceIvLJKBRFcNnMldPootjNB8RneW
         9j5dZae/1IPdbG8LOC2ShbVXp/Qibjz/xsuQ9+AAHH0im+e6xOMKzUgtueyvzUHG3qm3
         h9s3xGjbKciDs8eXcG3V7TTW/aVmqexSF5KyX2FOTMvFHlPVu/sanNIL/AyUwbb5jf08
         5qiRfz2uwzZI7Z5vJtNtrLy10Nq3oqbyzXXZb98Zbo6IQRTt0/8JsaGJdWQf/9XSEUGD
         1cRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=YBz2gLPjZvoutWGqZI+M3AwJew3pzLAmArebHkk7mtg=;
        b=NLKYhhCuTM3emM7ulURwR/lgnW5Jxy/aQ80mGgatVQPMtVOlGiwRbX8/qjBd/0HrcW
         k0zr9u+OdTfRJ9o0OjSZRkaURX/l7+zZZ9kXLeA0uK6p/fmynrt4hHev70wQHQklIIiT
         WI5nVw4eIUKlUf3Kmn20rEiN0K5Csqf4zyr6GKrZcAUtaEuiDh1QvqviPC0H4UpyvfKb
         kEX4YAxPRP6m026qGrLsrcQ203u9jFtFDLvUAd8TGGLW7Kq1HTVxFlMhywi4FSRBGfiI
         Anr5CP3qy06PwVHvI8ZIioRQ7ogR3lVazihV/q5jTnkSutnKaDRf3rA/uz94gc3twli0
         W8kQ==
X-Gm-Message-State: AOAM532XujDy/IyUJpR/uyD3gtO0NHLtNhdNfragG5d15BVpQpQ5CfGN
        4THiKU9eSGycRTgsUeNS8Wh+kR1NHbid2fsB
X-Google-Smtp-Source: ABdhPJyoLJMuDqCOxteoS9TojQPbCIcnskvAmMSd2k+/Z1Xs+zNuDGf2HfWIG/yaPPSs5Y59NI7Ohw==
X-Received: by 2002:a17:902:6b82:b029:120:3404:ce99 with SMTP id p2-20020a1709026b82b02901203404ce99mr18546458plk.49.1626689571122;
        Mon, 19 Jul 2021 03:12:51 -0700 (PDT)
Received: from smtpclient.apple (softbank060108183144.bbtec.net. [60.108.183.144])
        by smtp.gmail.com with ESMTPSA id a23sm18859205pff.43.2021.07.19.03.12.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Jul 2021 03:12:50 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH] net: Add netfilter hooks to track SRv6-encapsulated flows
From:   Ryoga Saito <proelbtn@gmail.com>
In-Reply-To: <20210715221342.GA19921@salvia>
Date:   Mon, 19 Jul 2021 19:12:46 +0900
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netfilter-devel@vger.kernel.org,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Content-Transfer-Encoding: 7bit
Message-Id: <0B18A029-E4B5-4D74-AE9E-C617E5325190@gmail.com>
References: <20210706052548.5440-1-proelbtn@gmail.com>
 <20210708033138.ef3af5a724d7b569c379c35e@uniroma2.it>
 <20210708133859.GA6745@salvia>
 <20210708183239.824f8e1ed569b0240c38c7a8@uniroma2.it>
 <CALPAGbJt_rb_r3M2AEJ_6VRsG+zXrEOza0U-6SxFGsERGipT4w@mail.gmail.com>
 <8EFE7482-6E0E-4589-A9BE-F7BC96C7876E@gmail.com>
 <20210709204851.90b847c71760aa40668a0971@uniroma2.it>
 <FEF1CBA8-62EC-483A-B7CA-50973020F27B@gmail.com>
 <20210713013116.441cc6015af001c4df4f16b0@uniroma2.it>
 <20210715221342.GA19921@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

I would like your comments for it.

I have 2 implementation ideas about fixing this patch:

1.) fix only coding style pointed out in previous mail
2.) add sysctl parameter and change NF_HOOK to NF_HOOK_COND for user to
    select behavior of hook call

I believed SRv6 encaps/decaps operations should be tracked with conntrack
like any other virtual net-device based tunneling protocols (e.g. VXLAN,
IPIP), even if the forwarding performance slows down because occurred by
lack of considerations. and any other tunnels also have this overhead.

Therefore, I support 1st idea. However, 2nd idea is ok if the overhead
caused by adding new hook isn't acceptable.

Ryoga
