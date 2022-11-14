Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51A3EC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 17:47:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235961AbiKNRr6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 12:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236963AbiKNRr5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 12:47:57 -0500
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223C825C0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 09:47:56 -0800 (PST)
Received: by mail-qv1-xf2b.google.com with SMTP id j6so8190350qvn.12
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 09:47:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foxtrot-research-com.20210112.gappssmtp.com; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jT6M4S56M6D9cMdnYJjo3BPQ9aWS21L96IVoMZNlIKs=;
        b=fsjTt/EzEygpIXCuER9KbJiXyKYn6svyQZFKYjD90J5OHBJKuSv/jyMOJgUu8UXEi6
         jXsWalnCdktNJdtAHuHjBXZJlpn6lTHyML3VmLM7Mr0fuzN7NC6YofyKJHgoQTxQYn3J
         FPvdlEQiyHLAmKIEgLwGAW9vlKcfUv6BKl5gweh7YM94tURz01SdCqQxNFeJCyHjJPKu
         fZcCR6MyEThk4xKvVRc2Fq7smY57+G3bmw7Ml0hRrz98vDsT7D8c9gbnnVlSCzJGIDmp
         yGMCJyeJUJV4Z2DIPVgEjr1jiCgC9l5N4cX0WiKXDoj0eEPT9A2b6OLz860KB8T1cx4z
         AJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:content-transfer-encoding
         :mime-version:message-id:date:subject:in-reply-to:references:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jT6M4S56M6D9cMdnYJjo3BPQ9aWS21L96IVoMZNlIKs=;
        b=E6qRfA4o8BvV31JR9D3BLbLn3PgexwU92x/BTUUARoNSRstGool1/6Ld9eGK/3vU4g
         W/1OMbq59uNPKiwNyeibnNwctAjhpbiZcte+LmAcnRnh63hIzobEfwBXKNk7cUaFO5oQ
         QDGkkEl4nprYuXiUqD4+YXJ1KhCyUnr4BSVE0ESG+cLkniFqg6QDnlr3uZByfM0z/Ay5
         cuFYG3UQG9IBmySj4yvPpqhn8nI77sDYGSTRaQiVO+4ZlCweHESDV/wSl7tLvGaEYn5+
         u0RRO3y7HO1bHh4isnw0K/66jj1sihJrKKSPv06SJcnWg5tPDhqJk7BB1b7oQBLxlP3k
         Lc2g==
X-Gm-Message-State: ANoB5pnHXlaGzFqZdR63F3Kb5QjFQudhQQv6FZ//0vM0yPQ6f7ULvpSd
        WziQN9t6/t38v6Mi5WN4hEC3I9wkT56jsA==
X-Google-Smtp-Source: AA0mqf7S/5qgf/q1gAKWMNGC3aNvfuh48QPwtIhMRgl+cQZ7T/b3RrCK171LFtlRrV/FlwWrroxXWA==
X-Received: by 2002:a05:6214:5e0f:b0:4bb:b9b8:602b with SMTP id li15-20020a0562145e0f00b004bbb9b8602bmr13295479qvb.131.1668448074616;
        Mon, 14 Nov 2022 09:47:54 -0800 (PST)
Received: from robrienlt (static-47-206-165-165.tamp.fl.frontiernet.net. [47.206.165.165])
        by smtp.gmail.com with ESMTPSA id r1-20020a05620a298100b006ecf030ef15sm6803780qkp.65.2022.11.14.09.47.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Nov 2022 09:47:54 -0800 (PST)
From:   "Robert O'Brien" <robrien@foxtrot-research.com>
To:     "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Cc:     <netfilter-devel@vger.kernel.org>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com> <005601d8f532$49cd7080$dd685180$@foxtrot-research.com> <Y24taNAVtz53JPDB@salvia>
In-Reply-To: <Y24taNAVtz53JPDB@salvia>
Subject: RE: PATCH ulogd2 filter BASE ARP packet IP addresses
Date:   Mon, 14 Nov 2022 12:47:52 -0500
Message-ID: <001c01d8f851$38ac6050$aa0520f0$@foxtrot-research.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIqBV8VmspvNYO5UtuFnxy3osxChQJpAr0CARzCsUitgGk2wA==
Content-Language: en-us
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I will create a bug report and attach an example ulogd configuration =
file that demonstrates the issue.

I will send a patch using git send-email and mention it in my bug =
report. What is the email address to where I should send the patch?

-----Original Message-----
From: Pablo Neira Ayuso <pablo@netfilter.org>=20
Sent: Friday, November 11, 2022 6:09 AM
To: Robert O'Brien <robrien@foxtrot-research.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: PATCH ulogd2 filter BASE ARP packet IP addresses

On Thu, Nov 10, 2022 at 01:28:53PM -0500, Robert O'Brien wrote:
> I am developing for an embedded target and just recently deployed=20
> libnetfilter and ulogd2 for logging packets which are rejected by=20
> rules in ebtables. While performing this effort I discovered a bug=20
> which generates incorrect values in the arp.saddr and arp.daddr fields =

> in the OPRINT and GPRINT outputs. I created a patch to resolve this=20
> issue in my deployment and I believe it is a candidate for integration =

> into the repository. The files that this patch modifies have not=20
> changed in many years so I'm thinking that the bug appeared due to=20
> changes in another codebase but I'm not sure. Please review and =
provide feedback.

Could you post an example ulogd configuration file to reproduce the =
issue?

> P.S. I could not find a way to submit a patch via Patchwork so I am=20
> writing this email and attaching the patch. If there is a better way=20
> to submit a patch, please tell me and I will re-submit it that way.

For patches to show up in patchwork, you have to use the git =
format-patch and git send-email tools.

Thanks.

