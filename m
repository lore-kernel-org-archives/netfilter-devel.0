Return-Path: <SRS0=bWeD=TS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13B9EC04AAF
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 13:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D59AF2087E
	for <netfilter-devel@archiver.kernel.org>; Sat, 18 May 2019 13:54:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pp8oDXQv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729323AbfERNyA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 18 May 2019 09:54:00 -0400
Received: from mail-vs1-f43.google.com ([209.85.217.43]:32787 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728557AbfERNyA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 18 May 2019 09:54:00 -0400
Received: by mail-vs1-f43.google.com with SMTP id y6so6456219vsb.0
        for <netfilter-devel@vger.kernel.org>; Sat, 18 May 2019 06:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=G4/bS6ZbHRExSi1v1tHnPQiB+RzXCW6Q4jUtTrK90w0=;
        b=Pp8oDXQvr1z59b2Iloa4kgHkE1FAYzoedGd5s7YIrNuKIXmN0Ii2kB7u14sF3ql5sB
         WgvqiiRO8aEZRHaEsb4k6h0DBSBdNRpo3qWvfQHCCBABatFoNY6JcfpwxhENoirffDMz
         ycdvRwsT1utHW/B8te5fK7IC0vDwltxjGSSaiL3Kj2uYe7ViztF1nDwq/9CAGcHXBTHF
         S0fG+Mi2KnbbzlRkymej/JcIKcEGu779DXxFBf4saQ4geQ25zV4eG/ZfKKKHcbmjbSvd
         OVOGJhl1G6MfPLglg2Z2iEy/+UQ1x3nRO7gr8NZmc8PyJVtgIk5l00zqp+WgH7VChpb6
         RsCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=G4/bS6ZbHRExSi1v1tHnPQiB+RzXCW6Q4jUtTrK90w0=;
        b=oEhplQ/hYChmimFZyBdGJ3lZb06o9h0YOsAJSxHbKrvUkIn9Zsy7YdgCbwHw3gSwtQ
         HZ82n+l+DDBcs8tDECBRf/pfN9ThU0K6Zg2q1InYfRsK1VummyMVKGWBx/XYpK0pFIer
         xITvT9ZvNMQnR9ZO/Nctlzf7rw2g4rDZ0B4ifLJq770BOWfI0NCdRr1ZK7R+yHdVr5IO
         +mrUqugJjZlSbz6QDlnaTTb3UX4lkrHz5xJdamWApnIVWY8GU3csBRh1o1p+wXVIYPP+
         7O0R81F2m6gl3fTPzXs07waHDQ16IvACMobpWAojhH2Pm+OYk2Fn6bll8puWA604thyy
         tX4w==
X-Gm-Message-State: APjAAAXkzDzBsGwgGUaM9tJSVlys7xR6Wr3N5U5oTUO0vMFLbp0KHaBc
        cjic8O6JcATiGxHyAMuCmO8wmyMzIJbF8mj3vNBscw==
X-Google-Smtp-Source: APXvYqy673HkbwmauBAOItBpXx/qaqZaCO6DuZr5B2/XLrvP1hnv8IvHleV03YaFma6OdXxdgN/NnYNMF3VaLcQEi0g=
X-Received: by 2002:a67:f7d2:: with SMTP id a18mr19793683vsp.5.1558187638807;
 Sat, 18 May 2019 06:53:58 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sat, 18 May 2019 15:53:47 +0200
Message-ID: <CAFs+hh7TAWAG9T9kgB2SS8m-xcQQWD4ormR8VT98RXe84MQREg@mail.gmail.com>
Subject: Expectations
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I think I finished the work regarding expectations. I sent 4 patches
(yesterday evening CEST) for 3 different projects : kernel, library
and nft (now waiting for your feedback).
I would like now to add a new helper module in the kernel to manage
RTSP. Do you think it could be a good idea/useful thing?

Regards,

St=C3=A9phane Veyret
