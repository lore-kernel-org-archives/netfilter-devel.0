Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F22EC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 17:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 617D561039
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Nov 2021 17:26:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhKLR3O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Nov 2021 12:29:14 -0500
Received: from mta-p5.oit.umn.edu ([134.84.196.205]:39652 "EHLO
        mta-p5.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbhKLR3N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Nov 2021 12:29:13 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-p5.oit.umn.edu (Postfix) with ESMTP id 4HrQVQ6CPjz9vHdM
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 17:26:22 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p5.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p5.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oiZeS1OonXGC for <netfilter-devel@vger.kernel.org>;
        Fri, 12 Nov 2021 11:26:22 -0600 (CST)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p5.oit.umn.edu (Postfix) with ESMTPS id 4HrQVQ4Xk9z9vHdL
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 11:26:22 -0600 (CST)
DMARC-Filter: OpenDMARC Filter v1.3.2 mta-p5.oit.umn.edu 4HrQVQ4Xk9z9vHdL
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-p5.oit.umn.edu 4HrQVQ4Xk9z9vHdL
Received: by mail-qt1-f200.google.com with SMTP id e14-20020a05622a110e00b002b0681d127eso6347377qty.15
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Nov 2021 09:26:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=d.umn.edu; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=SpdfITWTEBuNkr+83MF7mtV/0zBDQuMumkE2hkVmx8k=;
        b=gE1Ql1zfj7DymVcJIAZLcvvlycseZn/TD90U5hB8oJmboWSrwoTfprpRnjUqzUycot
         9RShwQRkRboQLXk2W2J9b6X/YCVZZJ8OyulfsbFGmJk1esw72yMrscLZkgVhHa+PFC7U
         jhL4KeB5KfZwGYS9Rul0pzGnhJ092DXTS5f25A6wjcYpBxzchVfk7wVk5LGMB5ZUpobH
         qFrK2eB+QZBPznzq5gu4cNu9k14gPVO+CENHpP+happWTU5RnqmVjbv0hnV9DEHOWUS5
         NecMaFeubEZulREXvxqex+GDfpUKFghzbbbqJxx7e5/X9kLIMjB1S7D0EP+r20jXws4b
         JLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=SpdfITWTEBuNkr+83MF7mtV/0zBDQuMumkE2hkVmx8k=;
        b=W22zJl+iRxCjVHDsnVx7uW7UF++TUCOrwkSLoRaVX3RDNgedUFaDgesJ9T8vTQzS5s
         EB069Q3E7ZnUZ7KsZoLpjVM+Lcu25gFa8vRyvx88d0IXW891DTQ2ZHE/hPnsjAy+y/JX
         HVHI8xZWu1V8QQBvkv5m6j/wUlvQTNqj+ldMOCuT3ANOhKy/AvtnWGhgLcgaefmj3uKv
         1H6yPfTwRCZtWkAcmLcl7W2X5GsyDENEH9OSW/8QYKPo+YmT87AVnhyZ39Wz2iPxVM9W
         FKQiNhe8UwossgKUz+CFBuWsPOcFAppA5JmTl8whe5P/lwTIbxSKd7dY4YUtiA6qHVM0
         x4Jw==
X-Gm-Message-State: AOAM533BeHDFpBG0Ge9XuycNOy6rz5B9plGryQBfF653/YWml76qF3G2
        pi5wasktekZJHWafP1zxsIxy28dHBVqDpsu9e0Vc9wPOwOCM7Gq/hy4FiVLfaSKnO/8fZYwfWRc
        3JoxkwybuTJbC8SJcCKnsxe16Y66litUe9CJNeIMSU2A+esRg
X-Received: by 2002:a05:620a:45aa:: with SMTP id bp42mr13752032qkb.3.1636737981978;
        Fri, 12 Nov 2021 09:26:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNk5haLoKGiacdQ6+JvsKBnuFvtQ5ClEhcmTEkv8YEcOYcyiu0oiSJlKhsYuSkxg2BhWqUi52tInrVt38nNNk=
X-Received: by 2002:a05:620a:45aa:: with SMTP id bp42mr13752005qkb.3.1636737981762;
 Fri, 12 Nov 2021 09:26:21 -0800 (PST)
MIME-Version: 1.0
From:   Matt Zagrabelny <mzagrabe@d.umn.edu>
Date:   Fri, 12 Nov 2021 11:26:11 -0600
Message-ID: <CAOLfK3Xq-vre2+vG6k4shjKnEJ+Dq=-z1isVCsgqNLjh=xxfXg@mail.gmail.com>
Subject: redefining a variable
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Greetings,

I would like to be able to redefine variables in nft.

Would you folks consider a switch or a new keyword to achieve something like:

define ints = eth0

define --redefine-ok ints = { $ints, eth1 }

define_or_redefine ints = { $ints, eth2 }

?

Thanks for your help and support.

-m
