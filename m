Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D50C43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33F572067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:08:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tGn2zMiE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbfDYPIe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:08:34 -0400
Received: from mail-ed1-f50.google.com ([209.85.208.50]:45761 "EHLO
        mail-ed1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727775AbfDYPIe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 11:08:34 -0400
Received: by mail-ed1-f50.google.com with SMTP id k92so157640edc.12
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2019 08:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=k/KlRwMI5wpRzOnycZC4FXWkQrzJagNhxTP8WQwxzoA=;
        b=tGn2zMiE7ZSK3vxKFuQLKTYTpFkh5Ov+JowmMI7ZmvS+To59V2XUKTgbIhIkR5js5H
         o67/odSPO9xcbeie1/urf1jTqjXdQdjQHBIRLDThYNGgLy6ThH9hcA4pVL05AwvSZVof
         xhsUzPvsEx2d7NFNChjRl5QV5HeN9ji7ML3MaeD75WPf6Bxf2z90Ecl26DtKPwi28f+/
         rPvy5ZF2o/FWAk01gpUl1oQ9iwd+Q2pfKgaAIwv56zczAhCogWDlSS0QuJlsOylsW87h
         pPH5EuOHxEi1A9UZkHxK8rpuZgr3ctxR4XDnkxsDU2RQfr7iDig5qv3Y/PNh3YKJMb1M
         FP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=k/KlRwMI5wpRzOnycZC4FXWkQrzJagNhxTP8WQwxzoA=;
        b=cSpK0DwqgTgPX8UpZ4oFY6yndUM6pnhARKMAOzSCPgi5i+J+PKkzP3QcNJGZOJ42Yl
         Yvc2ofDf2qy98ls5unAMyO7vsSznd7RHA5t/asCEbyvsr92k4u23FpMCrlkFrUfpelx/
         DicA2iciqmkmL8/pf778bIJ+IhT7CvvmrWHVCPJC8DTvqt/tVF43Diee0uftkFbt0YCy
         tsxbswv+QcP01TLdfdcxnQWPlBWKUOHIqe9SeYIb8+9vosCBO55NL35PWlRmrMTnFVzT
         OmanvrSE87MVkXjt3NzhXQaoVT95rICqI6k9JwlJPavom2AA66fUFNCUqsFsxsX1eQTu
         TVQA==
X-Gm-Message-State: APjAAAXZSNe52sUc7S6VKqZ5yz9Y4HCoSQdvq1X3emvPMjtqxRGjcbR+
        0gmY7hphlBFjCfUzYTdb9bHOOz0w+yJN6rFWwc9rHsrnwIY=
X-Google-Smtp-Source: APXvYqzvXcqfUhv7TqLdEE6GXVICfSPw0gTDT/uEPx9zb0AGAwwoS5ijoaj4FJbiKCg20Ic4TjTh/NeLiKs23AeZ4ys=
X-Received: by 2002:a17:906:d0c7:: with SMTP id bq7mr5094690ejb.77.1556204912511;
 Thu, 25 Apr 2019 08:08:32 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
In-Reply-To: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
From:   Mojtaba <mespio@gmail.com>
Date:   Thu, 25 Apr 2019 19:38:20 +0430
Message-ID: <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello all
I read man conntrack document guide. That is great.
I have a issue while i am working on it. For example i just want to insert
new rule in conntrack table like this:
conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
--dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111
--reply-port-dst 2222 --timeout 30

it successfully inserted but doesn=E2=80=99t work and traffic will be go to=
 INPUT chain.
if i insert these two rules in iptables, the same above rules will be inser=
ted
in conntrack table automatically and works correctly.(the traffic will
be traversed to 192.168.122.1 host)
iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242
--dport 5005 -j DNAT --to 192.168.122.1:1111

iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to
192.168.122.103:2222

Who can i solve this problem?
With Best regards.Mojtaba

On Thu, Apr 25, 2019 at 7:29 PM Mojtaba <mespio@gmail.com> wrote:
>
> Hello all
> I read man conntrack document guide. That is great.
> I have a issue while i am working on it. For example i just want add
> new rule like this:
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> --dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111
> --reply-port-dst 2222 --timeout 30
>
> But it doen't work.
> if i insert these two rule in iptable, the same above rule will insert
> in conntrack table automatically and work correctly.
> iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242
> --dport 5005 -j DNAT --to 192.168.122.1:1111
>
> iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to
> 192.168.122.103:2222
> Who can i solve this problem?
> With Best regards.Mojtaba
>
>
> --
> --Mojtaba Esfandiari.S



--=20
--Mojtaba Esfandiari.S
