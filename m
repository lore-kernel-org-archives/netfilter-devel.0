Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96121C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F768217F9
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 19:05:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tanaza-com.20150623.gappssmtp.com header.i=@tanaza-com.20150623.gappssmtp.com header.b="sonkycj1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbfLBTFM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 14:05:12 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37902 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfLBTFM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 14:05:12 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so644749wmi.3
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Dec 2019 11:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tanaza-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:message-id:in-reply-to
         :date:mime-version;
        bh=cpDuQ+8S1NqmWh2GgkrifCfeM8SlTPIIbhI2n6BWOvs=;
        b=sonkycj1mFy8Md475zDtj1AcFk5pt6Lup/DZrpQiH9Mku7PBXg96UbiXN7bNn3Q6gu
         LvdWF/DqMoCYIoLf1KYLQh5fE426TWIrDjM8ItYYFYHzaP0iaRQwRES1ZA3KRxOhGpRP
         UiEYYPcYklySl06jvrC9Y6BhpQM3IX+KEqNUfJwBKTAiuqk2WwL3LBEASEM2tLQnJCjR
         p4Km4TTqKack3gX3zFL5efSJmCQHtO6rHK9fm8ZXmmjsfZ1MBuRrNKPROyjfzs+xBrRF
         WRaOGLWo7r1qu8/CYAKzaY0E6HlX8/1Th6zpmZfxp9zpvBDDlO+gtzu/fhlNiLVFy/Uy
         oRpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :message-id:in-reply-to:date:mime-version;
        bh=cpDuQ+8S1NqmWh2GgkrifCfeM8SlTPIIbhI2n6BWOvs=;
        b=c+PwS+TCb8zuBbvNFmfH6Ly8+AUHSgkY6ulmtI3BOShzRvCZAMfWumR6cBvaFvdkph
         hNwH9G7tejsL2xUi0Dmop7Q0E+/t1bFc79FP5ElDpCNcvik+76zkkG4T13v96juWsSzX
         XELIUVu2bgQ6tadR39+grFVfgx8rPtYhHET6pLRXOj0Oc7xnl2oDR9TRD8Fkks0+gZwO
         vwMkX5+UTD6xgynNLKtcRRaY6BeTnKgEHfsHoWpACfQ0gf/Yv41GPHLZVqsxayvZokbJ
         woueHL35fVAwjBvdmxkbaqVsUyYElrIcQsqOZDDHhs1MLeYpiNVR+V7qkTN99cMY5L5L
         D44w==
X-Gm-Message-State: APjAAAXjD2ys1HPyZm1/P0PmeCNrICAHUTufM8zfkT454AV8WgrlYGoA
        UAAWC7jzpyCmWPaAllFkiX0yQw==
X-Google-Smtp-Source: APXvYqzXJDiESvArk5u/jax/qwNnw5RQ+BTZyzJ0XCZtnxIJWw8vPfN7p/aPNd9ERrjj1W1VOi5jTg==
X-Received: by 2002:a1c:3d87:: with SMTP id k129mr31825358wma.26.1575313509766;
        Mon, 02 Dec 2019 11:05:09 -0800 (PST)
Received: from sancho ([37.162.99.119])
        by smtp.gmail.com with ESMTPSA id c2sm378380wrp.46.2019.12.02.11.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 11:05:01 -0800 (PST)
References: <20191202185430.31367-1-marco.oliverio@tanaza.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Marco Oliverio <marco.oliverio@tanaza.com>
To:     Marco Oliverio <marco.oliverio@tanaza.com>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        fw@strlen.de, rocco.folino@tanaza.com
Subject: Re: [PATCH nf] netfilter: nf_queue: enqueue skbs with NULL dst
Message-ID: <87r21mv9aj.fsf@tanaza.com>
In-reply-to: <20191202185430.31367-1-marco.oliverio@tanaza.com>
Date:   Mon, 02 Dec 2019 20:04:37 +0100
MIME-Version: 1.0
Content-Type: text/plain
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Marco Oliverio writes:

> Bridge packets that are forwarded have skb->dst == NULL and get
> dropped by the check introduced by
> ...

ops. sorry for the multiple emails, made a mess :-)

Refer to this thread.

M
