Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D32C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 12:47:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJFMrB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJFMrA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 08:47:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6352A033B;
        Thu,  6 Oct 2022 05:46:58 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id x59so2632464ede.7;
        Thu, 06 Oct 2022 05:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date;
        bh=TSQwygCFcZALa3sAZdIWMA5u8XrCQsY1FzdV6+Hipzw=;
        b=TWbQSJERx43SxvXXXLZtcblxRN+si6cLYqYe6SqWHbTMiZQnE5dauSQaAsZIacaFJt
         oDAZZqXa4CzLTgXcs7LlUv2pJNei4Cbf96Xs0EAcUp2Mak0RLItrYE48sGw/m0iqOG0m
         sADJe8DL7f6gO07MY02WH62M/gXk/3YTdqi63NAjbkIyMJdWo3vlQq1yK5QQJjmgCt8n
         0LVEv33mw2Ce2fCtBTGt0E0ZuuXYF5KonAp5DBz3Ik8ntvJHT07abj4jdLdgqqCI9ezE
         MXj5X1Vosl+NIhBg/Lze8exZsj7zM+o8fMN+QazVtLy/SGtLgBhY1zqf5Iz1nlZ1KyF+
         JXHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=TSQwygCFcZALa3sAZdIWMA5u8XrCQsY1FzdV6+Hipzw=;
        b=mzLA2TOX7381zQO/LUicgPAXGYXihb698ccsfYL/arb50cpQPRp6+64KczkCIZtMJi
         79qbi//2lzunhFQ7lJtaxDA12HCFz+VMuQ15S9Xwi7ExObbabDMjLxPQabhx00X+nCK7
         yNOHAUEe4VDwp/4EEGf08zH/ehIXqBq4LYsc0k4qeJkJbNQoySfJz+yDvj0mMkkq9jfN
         1sQSWFOFZZhT8QpbGLcLOPkYAOfhysZ+qp7xk/pW/nUruyvzqJK4Y5MWvXb2rVrwsL68
         Eg2EEETjYlKtZ1J/XBEVsmxTFQD1yCDSO66bDPNVyxv97KOSvhKI/DFiVD8BwgnAlFGF
         O+VA==
X-Gm-Message-State: ACrzQf2i900cZxMlX0FsOURWjRHzu53+xTb/1gdHfA/1//CHpRxS2B+b
        H0FzuBnVxs/3VyivD9Oi0Jo=
X-Google-Smtp-Source: AMsMyM6fNyKjNPZL+RpgDWIeIe1xFWDmPWgZWbNY6D+Hye0iwj04PyVHAZrdsmYk9FfjeAdy64ABEw==
X-Received: by 2002:a05:6402:2756:b0:443:4a6d:f05a with SMTP id z22-20020a056402275600b004434a6df05amr4460712edd.396.1665060416878;
        Thu, 06 Oct 2022 05:46:56 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id f4-20020a50fe04000000b00451319a43dasm5871231edt.2.2022.10.06.05.46.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 05:46:43 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: Kernel 6.0.0 bug pptp not work
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <20221006111811.GA3034@breakpoint.cc>
Date:   Thu, 6 Oct 2022 15:46:37 +0300
Cc:     pablo@netfilter.org, Paolo Abeni <pabeni@redhat.com>,
        netfilter-devel@vger.kernel.org,
        netfilter <netfilter@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0DF040F3-ACC8-447E-99DA-BB77FEE03C7E@gmail.com>
References: <3D70BC1B-A19E-45E3-B6BC-6B2719BA9B46@gmail.com>
 <20221006111811.GA3034@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Huh
Very strange in kernel 6.0.0 i not found : =
net.netfilter.nf_conntrack_helper


in old kernel 5.19.14 in sysctl -a | grep =
net.netfilter.nf_conntrack_helper=20

net.netfilter.nf_conntrack_helper =3D 1


m.

> On 6 Oct 2022, at 14:18, Florian Westphal <fw@strlen.de> wrote:
>=20
> Martin Zaharinov <micron10@gmail.com> wrote:
>> Hi Team
>>=20
>> I make test image with kernel 6.0.0 and schem is :
>>=20
>> internet <> router NAT <> windows client pptp
>>=20
>> with l2tp all is fine and connections is establesh.
>>=20
>> But when try to make pptp connection  stay on finish phase and not =
connect .
>>=20
>> try to remove module : nf_conntrack_pptp and same not work.
>=20
> Did you rely on
> sysctl net.netfilter.nf_conntrack_helper=3D1, or are you assigning the
> helper via ruleset?

