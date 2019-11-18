Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1846FC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 16:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC16A2186D
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 16:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="YzZJ9h8c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbfKRQoU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 11:44:20 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:42061 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfKRQoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 11:44:20 -0500
Received: by mail-vk1-f193.google.com with SMTP id r4so4258427vkf.9
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 08:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nHpM29TXqT7ArXiUprpU/q7JQvHtnIyKiG+hQM6dGq8=;
        b=YzZJ9h8cxFAzIR871EU8V511DYUD9khzjnBYo6k0fNPacAPc9NAf0Uf59G6241Cgga
         mjWQDxyxKvLI78t08UczHT7f83ov3tFAp3gjnWt4sOPXi2ZDtXJYD0kP8XSB6/4TfHRt
         ZntlY9hhVd/UGvDUxEvzQiu+mQMkoh8wgUuFWLvIvUk6l3+HQ2SujAdvTHH3YUQ8UxtL
         Hcj90oWY6Bfl/9r3Mnfk4HfnXJ4GsX3F3IhNa5jqRHeKMLhM3BAmNPM8yFrcqIJ2SA8I
         jX8nhGVBTEf+kP2HorKYNPk5RsHv8T3nzrFzGvjZ8rzdTjgcxMji4JxTxj/myzGnVzUs
         aMAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nHpM29TXqT7ArXiUprpU/q7JQvHtnIyKiG+hQM6dGq8=;
        b=BXnEA40Q1hvPZiuaWl9he3ZfE+ww/UbnmeSwFVciaCOP/ITUxzQ5FGuheP7NXSXYFO
         h9VE7nNOCyhT+9AH+PmdKgucGoccvE8JDYq1NndyiMsCljkaghKCUJDoGZXN9Vo5fkNo
         GK/301u9Hm7aDp9CFRjMkQ5v30bemarGOCEeBgCxKNchyyJ9gLlo7L3Iwnq8CXL+Wf7l
         iplj18BNX7AmMWzwZfpT+mcHnlEmrrMKymS2mpXtXX7gUGnjHQyW8IFW9Ci84XnF50HQ
         cliUhFdFipddgO/2lwWSU8NvXwnycWDo4AB9oUDqg8Tfufz13YgfS6+kG1zp2nXLNHo9
         Eaxg==
X-Gm-Message-State: APjAAAUzgKfrAubsMNl0EsTJ0MpGUhB8Be4xu2P2CruW4ss6nDKYv7W+
        jcCS41ASmgEKxbPYHAC7OFuRPUEhqTfF6z9nay7LkEkdiXA=
X-Google-Smtp-Source: APXvYqxO77dPyR8ccvEtmvp1Lb2GMB2zsKHqkAQHUYTnn5ayX4ADNI8Q0hOb1ZJuxVVeMWljeZG6smoFMX7Cr+gpMZM=
X-Received: by 2002:a1f:9d4d:: with SMTP id g74mr840207vke.58.1574095458992;
 Mon, 18 Nov 2019 08:44:18 -0800 (PST)
MIME-Version: 1.0
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
 <20191022173411.zh3o2wnoqxpjhjkq@salvia> <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
In-Reply-To: <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
From:   =?UTF-8?Q?Christian_G=C3=B6ttsche?= <cgzones@googlemail.com>
Date:   Mon, 18 Nov 2019 17:44:07 +0100
Message-ID: <CAJ2a_Df61oAEc4NSFZneThOpwQcsmmjf7_RiV9y-bePwYO-9Sw@mail.gmail.com>
Subject: Re: nftables: secmark support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am Mo., 28. Okt. 2019 um 15:27 Uhr schrieb Christian G=C3=B6ttsche
<cgzones@googlemail.com>:
> > This is what your patch [6] does, right? If you don't mind to rebase
> > it I can have a look if I can propose you something else than this new
> > keyword.
>
> Attached at the end (base on 707ad229d48f2ba7920541527b755b155ddedcda)

friendly ping; any progress?

rebased against 4a382ec54a8c09df1a625ddc7d32fc06257c596d at
https://paste.debian.net/1116802/
