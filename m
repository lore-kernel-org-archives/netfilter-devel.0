Return-Path: <SRS0=L7DL=Y3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92E30CA9EB0
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 11:14:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63DFC20842
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Nov 2019 11:14:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sylxUZFp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbfKCLOf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Nov 2019 06:14:35 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35564 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfKCLOf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Nov 2019 06:14:35 -0500
Received: by mail-ed1-f65.google.com with SMTP id w3so8646157edt.2;
        Sun, 03 Nov 2019 03:14:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=5o1Qh59bEfFHZT6OcFAVdeEilPh4rVY2q0THO0SXj+g=;
        b=sylxUZFp1Ietv/2hqpWtCVnMu2fUE5juHJJQN7t5FwcNqCR/XvjwaOfdlEVG8Y1e9U
         aYr8jbV8kf/QhvLhYIWMjsdzAJxIk7fOX0995vZTahrGPIRqK2F+0zGkb1snOuZOsHKe
         LfAdZVIGw+5UP2gx7a8uqnSRANSFeLGixanr23oa5UjGkmsORAzrKlnxUDMKiXDVbUAB
         92FPCBuRdPtJz8E3od3+grcQn0iPWXMR69y8pWUNFCR4yxPlb+6mQOurB4v9f0+rvIcA
         bLEOzAb1GhCNY5LAd7BFUO8l+ovA4/EYsxF99UyJa/IIVQJI9lxX5jygk2fH+ykqsAoi
         9YyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=5o1Qh59bEfFHZT6OcFAVdeEilPh4rVY2q0THO0SXj+g=;
        b=j1amyAguS8L+Hn4NhKm6sy++2vWh3bIA2XmOtcy+6J4YuBSyidn1SDpQAHGSow9R7+
         lHCGrcOCdeVbt3WgbCjgwrnOGZrekVpFNKTbsatzxBwOGneM3TGetHASHMWzO8RTPxlD
         LowjTq+HS60nz/MYpbKNeVSpaHac0BSEVAWUgLi4taL8kUC0yw+BVudkkoLXHQByvymL
         MuaIz8iBjmr63Vedh9KoQ5t6335V2N791FfKq1CTRzWmgcQdbnFdB1mxzjwOGk65mUcY
         yCSrtX1LE92wTFAO60iWgmef2foQljsFv6czRz0l5UajTOgrKitQ6H328NUDgVtm9hIf
         A36g==
X-Gm-Message-State: APjAAAWYisk0hIcqa0mAMIFMgBezdiVYMDedqn2bbrVFQUmxUYvih4xD
        Xb2uhbbjCgW3sE1ssTbnz6sHOUbU2egQflQ0MJK7CQ==
X-Google-Smtp-Source: APXvYqz2s+ukNO9znqtYvIol/AbmSLUO2hhBMJWuNXbnS6T2Lemt/YnyWNF4cSQME2k+/sm2c9MM6CybZ6M7NxHE0Ms=
X-Received: by 2002:a17:906:70d2:: with SMTP id g18mr19294873ejk.18.1572779673700;
 Sun, 03 Nov 2019 03:14:33 -0800 (PST)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Sun, 3 Nov 2019 19:14:22 +0800
Message-ID: <CAGnHSE=RxEesfAnzhHi+qteoWs1Mpc5BVWPn8zteEGqpTbgMeQ@mail.gmail.com>
Subject: ebtables dnat rule gets system frozen
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel version being 5.3.8, after adding a dnat rule (to the OUTPUT
chain) with ebtables-nft in iptables 1.8.3, my system is frozen as
soon as I ping anything. I couldn't catch anything with dmesg -w. Can
anyone reproduce the same issue? I am on Arch Linux.
