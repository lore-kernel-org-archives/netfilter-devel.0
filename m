Return-Path: <SRS0=hHnn=X4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80703C10F14
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 10:03:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F3E2133F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Oct 2019 10:03:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvqa5pFl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfJCKDI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:03:08 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44061 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfJCKDI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Oct 2019 06:03:08 -0400
Received: by mail-io1-f67.google.com with SMTP id w12so4029661iol.11
        for <netfilter-devel@vger.kernel.org>; Thu, 03 Oct 2019 03:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=haN053pXPW+4JaMfooKbsrH8qmubXQo7WvhpyXsdHjY=;
        b=hvqa5pFl3w9VkMa9GociF/dgixJhCajjgAcqJ/KcEl2UKZd6w9Xi8PmWhiTV6/Idtw
         BexKytsVepe01JRl0lwKtcvKFp8ZPtwTVtCGA5zURJvQFjfq6K5YabA8L97xiapghp/C
         7CqOOhVtRRkOn8kQAouC3Cw6s/mOVY5iZNJ0ON7q+9qaov5SK33K4viKKSCQ496m8mvb
         TLgFXXboxBiMC3YlnC5XL4FgLd/JR5G0MWEh3N2GzOj9fso72SUhHSdsgRAgiLk3vvHX
         7MJ8n0+cGDPe+QPpjDxTeIvo8Sv9X7QbAUDmQYkY7fGaMCjN//uGrInYfIOHlrfjYTKF
         D7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=haN053pXPW+4JaMfooKbsrH8qmubXQo7WvhpyXsdHjY=;
        b=AgV8YzuKqDCCTNdJqaNMmoBVg/WU/Tn9IaZve1SfizZc9cYuzyewBBG0TOcC2cHo/b
         kWzouqFwn00PP6oBSPZoybjC+n/Z/ZXY0XIMkmzYa2C93HKw1YHOkNJFLnlvppQD54qi
         5UZe+8HOQ3Oq8LIibMlcfLYR02IaYSkO60KvNdFnniicMI6WRkUA351nXJf93INgkTrL
         vjlWDyPYoRBF/rARVqoUWfp8rGKhdANijDq9pFk/M5ob/4wtJtVHzYZS4YA3lbWDsRRo
         B41Cg7JcuCZ9T/pGhF+xrUdWUkE/xNpqqKRTf2rbivnVVoVnLTeJZG/X5+oZ40ZZoE49
         QfOA==
X-Gm-Message-State: APjAAAUizlpMqTZPGMffM02nXQjNxSyWmfT/2xgTTUgT6NprMXRQH+BD
        HhF8wo1WiaUIQSLpFV6IcztmsiwBOWcV8WQTbtAi8OtF
X-Google-Smtp-Source: APXvYqyDgU/m0fcXVLnztSPD3/4Aot9Zo+Gcz2LBSZzRPsZ0swgvu1V55YFvxpm3uCh4MC3hlyqhBaccUIN0qcPHbdI=
X-Received: by 2002:a92:bbd2:: with SMTP id x79mr9127026ilk.162.1570096987551;
 Thu, 03 Oct 2019 03:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190926105354.8301-1-kristian.evensen@gmail.com> <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.20.1910022039530.21131@blackhole.kfki.hu>
From:   Kristian Evensen <kristian.evensen@gmail.com>
Date:   Thu, 3 Oct 2019 12:02:55 +0200
Message-ID: <CAKfDRXiMFs5PswdukyWjb60HpoeaUXHG7Hj4gH5Hvx_-0s=-wQ@mail.gmail.com>
Subject: Re: [PATCH] ipset: Add wildcard support to net,iface
To:     =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jozsef,

On Wed, Oct 2, 2019 at 8:46 PM Kadlecsik J=C3=B3zsef
<kadlec@blackhole.kfki.hu> wrote:
> Sorry for the long delay - I'm still pondering on the syntax.
>
> ip[6]tables uses the "+" notation for prefix matching. So in order to be
> compatible with it, it'd be better to use "ifac+" instead of
> "ifac prefix". The parsing/printing could be solved in the interface
> parser/printer functions internally. What do you think?

No worries about the delay :)

Before submitting the patch, I spent a lot of time thinking about the
syntax since, as you say, ip[6]tables uses "+" to indicate prefix
matching. The first version of the change checked for a "+"  at the
end of the interface name, instead of the wildcard flag. However, the
reason I went with the wildcard flag, was that I discovered that "+"
is a valid character in interface names on Linux. One thing we could
do, is to remove any trailing "+" if the wildcard flag is set.
However, I believe such a solution will be a bit redundant, but I have
no strong opinion on how to parse the interface name provided by the
user :)

BR,
Kristian
