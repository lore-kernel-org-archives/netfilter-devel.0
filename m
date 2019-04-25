Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 369FDC43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 462992081C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:00:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZttyvoC7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbfDYPAL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:00:11 -0400
Received: from mail-ed1-f45.google.com ([209.85.208.45]:43185 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfDYPAL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 11:00:11 -0400
Received: by mail-ed1-f45.google.com with SMTP id j20so141979edq.10
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2019 08:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gMh+SzEKJei65OmHz5vb7PC0/lAvxPClu8CwAeFWjsQ=;
        b=ZttyvoC7MF3SWT1TGNm3Ammr0O+q/JmaS52RnuF4w1GwGjzxnL41fvyvJUq1GHigmk
         T+y/5qYtjbzblB+y7F/qZ9/8yIRXf5Fjgfur/3YgcQuk4KWfj8gmeJK8R//wSJlY/+qO
         R9dZc/OLr5VCz40ETl+ZNc3Yjb87+odMV4UARrAfk2AIIF7WkYIbm28C4Rncu4oIJ1Xj
         ZhLXRciS8/E8QVuYJL+sd3rUmvSEY61T8Z/gVeM3UkgpPFXxEkVL/MpshtOzKw/FfFWx
         CrWG23iUXN5gtUdNXRBRvLXCc9IEB77MOfU8v/1m0xODgrYYhw7F8qA9Xb5M7jLU/OcR
         9ZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gMh+SzEKJei65OmHz5vb7PC0/lAvxPClu8CwAeFWjsQ=;
        b=f0ix/fJyC4ibQAOJ+/O3pIYAnIyjekBKych0YGNiep5vZNgot1uN8Mv6lj971TIuBU
         dINgyLtPX9MNCmhclF9/PxZ/tgR5U9Ub+aFxU/80BLOauo9ZEpqWw4Asian1lgCp4Ry1
         EKZ6QFAsNNraiLZEWOVuVOqQSyoV8/Foxk6xbBUd33AAi1y78JiSTaHLr47B1Dxgll2h
         SJqUheSyB8mc3vY+Jg7RfQx6Ov7HktR3xbX/q9re601YUrR59FnbBngkXBIwx/Fnn3nZ
         pLu0wVx/bPv0bgHxUNT5R3HNdgFfXRaq0NMaWwWpZRHPZIYySDeJZN43ycI8sigho32C
         lP+A==
X-Gm-Message-State: APjAAAUzdUSMCfMlSV59Jxx4LhFQ4n0sh9TM+HtTDAy3jbI2hwUcoacc
        aPjuMxqQ9WJtP+1vIg/+dssgOqz9T/lTgpJqORYCXAwJRqE=
X-Google-Smtp-Source: APXvYqwsi9taDca0P5xEE4xpY+S+JeSyjx1bEuyDwCY2jKlB0P3N8Xmh3+v94FoVvGMsjECM5HwDsXXCqPfzr9gsvag=
X-Received: by 2002:a17:906:9a9:: with SMTP id q9mr12406486eje.171.1556204409756;
 Thu, 25 Apr 2019 08:00:09 -0700 (PDT)
MIME-Version: 1.0
From:   Mojtaba <mespio@gmail.com>
Date:   Thu, 25 Apr 2019 19:29:58 +0430
Message-ID: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
Subject: Issue related to conntrack while insert new rule with conntrack
 command in linux
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello all
I read man conntrack document guide. That is great.
I have a issue while i am working on it. For example i just want add
new rule like this:
conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
--dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111
--reply-port-dst 2222 --timeout 30

But it doen't work.
if i insert these two rule in iptable, the same above rule will insert
in conntrack table automatically and work correctly.
iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242
--dport 5005 -j DNAT --to 192.168.122.1:1111

iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to
192.168.122.103:2222
Who can i solve this problem?
With Best regards.Mojtaba


-- 
--Mojtaba Esfandiari.S
