Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94FE0C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 19:57:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 671DD2086D
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 19:57:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bsREio19"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfF1T5u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 15:57:50 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:37324 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfF1T5t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 15:57:49 -0400
Received: by mail-yw1-f68.google.com with SMTP id u141so2096096ywe.4
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 12:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Zbt8t4OGSrBZUltQdpu2XfV4/PLifVH/Z0A6OyR0+8=;
        b=bsREio19ZCYiktCkIASujl5tmzasz+I6GbX0QwjW1yWtrPHLtl8F72d/tP0OV718gu
         JhET9fkvZSnspuxgKrEOx/1kP1SYjQ7fj0fI/XoKoCGyk+qi6UDO6wRJo+hNRVYcyyxq
         0JSncshPTPt64doooXNY6ma4/ktV2ka0yVK/xrE/yAYCFGpIjfHmlQ4eCCCi+mJeJUsc
         8W4PI0vw66GNUmY1JGqXcSHa2CiCZHRkpxNiXv/kZ+fttkGp4qs1PP7G81iPFP6xFUG7
         n7G6MbZWqfBIpLiVXTzG3xd/E7GrLNqS/TCCUVcsr/qDjsGrDy2eGI721OOsI6wgTV9h
         S/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Zbt8t4OGSrBZUltQdpu2XfV4/PLifVH/Z0A6OyR0+8=;
        b=BRLZGBnc9blNeI5QoNuJtcKIdAFcy67qBznUooKbhNKdV3IwV/mkA6ScBRm6+2OkZ6
         AzF0obgdRSjNT98to1mMfLb/oGGxJ0wBgXVJO805J3qk58C5XOL0EXr7jOaEG86C0ofz
         uADcsXnKVF5232ilHBpe6Rg9ixTKeqO+uxR1LVPsmxDnuCq7dyQx/M2sqLrE6Rbk4FZt
         BV1jNHpFMp6MsJUc+UGxqfrPOVxyEu7A83uJifa6cbacn6BY+cr9QZ0eG/ThWyWsT2BM
         vPb6Th+w7AuR0aGtcpGvljD2U9CRJq6EglvC/bLQQBAlpdfUm3dceIiHsWtFe9eWtbP3
         rTdg==
X-Gm-Message-State: APjAAAXqy2aONTlsetEWRnu7e9XlIuKWSyD0uuXS7eTAtzAqIPHu214X
        uyJJ2epRSs4f2sM7DBiuccH20mDyows=
X-Google-Smtp-Source: APXvYqzV/xnnfRD8UwDo15+wFrMvnZjXUErwdLa+INb+DChOeCMBvyIo4/jzCee6U00TtwmcGCXwzg==
X-Received: by 2002:a81:3bc5:: with SMTP id i188mr7326985ywa.72.1561751868584;
        Fri, 28 Jun 2019 12:57:48 -0700 (PDT)
Received: from mail-yw1-f49.google.com (mail-yw1-f49.google.com. [209.85.161.49])
        by smtp.gmail.com with ESMTPSA id v203sm207246ywa.37.2019.06.28.12.57.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 12:57:48 -0700 (PDT)
Received: by mail-yw1-f49.google.com with SMTP id u141so2096035ywe.4
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 12:57:48 -0700 (PDT)
X-Received: by 2002:a81:8357:: with SMTP id t84mr7023115ywf.109.1561751559659;
 Fri, 28 Jun 2019 12:52:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190628123819.2785504-1-arnd@arndb.de> <20190628123819.2785504-3-arnd@arndb.de>
In-Reply-To: <20190628123819.2785504-3-arnd@arndb.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 28 Jun 2019 15:52:03 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdL=GwjhbERsePAJfbakgEQZb7X51UHw=+4R9dJD3JD4A@mail.gmail.com>
Message-ID: <CA+FuTSdL=GwjhbERsePAJfbakgEQZb7X51UHw=+4R9dJD3JD4A@mail.gmail.com>
Subject: Re: [PATCH 3/4] staging: rtl8712: reduce stack usage, again
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Network Development <netdev@vger.kernel.org>,
        lvs-devel@vger.kernel.org,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Nishka Dasgupta <nishkadg.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 28, 2019 at 8:41 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> An earlier patch I sent reduced the stack usage enough to get
> below the warning limit, and I could show this was safe, but with
> GCC_PLUGIN_STRUCTLEAK_BYREF_ALL, it gets worse again because large stack
> variables in the same function no longer overlap:
>
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c: In function 'translate_scan.isra.2':
> drivers/staging/rtl8712/rtl871x_ioctl_linux.c:322:1: error: the frame size of 1200 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
>
> Split out the largest two blocks in the affected function into two
> separate functions and mark those noinline_for_stack.
>
> Fixes: 8c5af16f7953 ("staging: rtl8712: reduce stack usage")
> Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Willem de Bruijn <willemb@google.com>
