Return-Path: <SRS0=6ZhO=UO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826F9C31E50
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jun 2019 13:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D4B621473
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Jun 2019 13:10:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d6gihAVi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfFONKc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Jun 2019 09:10:32 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:37325 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfFONKb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Jun 2019 09:10:31 -0400
Received: by mail-vs1-f68.google.com with SMTP id v6so3484760vsq.4
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Jun 2019 06:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=JvQErW2S1udSTD8W0nTzqgcFzkx7AuoJDZc6dXCKJN0=;
        b=d6gihAViOoDzMtD+O+j56a9JU0yTVMsJyuN24C3X1UXDAd1xP13CIr7wzkENDSZpBb
         6mjwTCyiQO5Efdp/7GdmouIkWXmcwj0Ve/ij+ToagycMD3p89zwR26eXg//hzDr5wfwe
         v/X+iCb4nFbOpLoMGHaVlv9Nxikzu+NWVU4vwN8mo3Gn1BN3PE0B/kN3aimM7rmBm8l8
         6Uhn5HRy6g8Fg894Qx6vRiicciyPfKDoYEjlUwbeIxwXRYeszHD1QnjEMKCXqgIuazdO
         lDJpw4qB0FMBOMs2XLrggbwtNgVH5WlrEsp/2lu4wIdnGll7Ubj24MIcpi22F+MPPoOA
         F3rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=JvQErW2S1udSTD8W0nTzqgcFzkx7AuoJDZc6dXCKJN0=;
        b=BBdO97FdQp9kRlqyq5tF6+QtdRGEW55jnLGnuApWL23kpDsHpZ1Bo/ATwfxcbKtSRe
         9HHEmfzSYF5pj5vcFzfVVgbkdL/sXNlYH5m5Ddq3zZ6P7dq078IjlouuZ7QgdWYWD5V6
         ee7uFcdHlFYSjp4052IqFK8P1XNg9ronIYQlK8gUKbgEjBSNRYaL5eiebk1L6kLCtq1y
         GzXaEqG9OU+pTIlAQ9jKIXyQ7TcoR2ruEzPpNeeegsQXJ107pP58BY9R89Dgd+w4vH3U
         iryh9BHPIoa61VFEcXsMi8dwrHUzRZxbZrmI54O8NSyPSCXLnENH506ERQrUuQPXB/pv
         kUTA==
X-Gm-Message-State: APjAAAWet1WWNhkeQUdK1FhojRTIhdrdBfnSBWVwGkV1cRA89TYsCgP5
        KJfF/j1/n4g3a+K/3uGSvyECmdvFPnY2eRX5iaitQA==
X-Google-Smtp-Source: APXvYqxzXbNo4v9nPv2AOSLaCIzO8mC+IAQxD2VXLAs326C7wE5t88MaKDzSGW2E/xuMkXnvvZ6zFRYGI4Z3ex8DokY=
X-Received: by 2002:a67:eb87:: with SMTP id e7mr44646819vso.118.1560604230422;
 Sat, 15 Jun 2019 06:10:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190605092818.13844-1-sveyret@gmail.com>
In-Reply-To: <20190605092818.13844-1-sveyret@gmail.com>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Sat, 15 Jun 2019 15:10:19 +0200
Message-ID: <CAFs+hh7wVDZ3B=4WeshN8JQgav-HP3z0qSwZYnEpNPU2aBnz+Q@mail.gmail.com>
Subject: Re: [PATCH nftables v4 0/1] add ct expectation support
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I was wondering if you had everything needed for code review of the
conntrack expectation support=E2=80=A6

St=C3=A9phane.
