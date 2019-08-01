Return-Path: <SRS0=uSEi=V5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8547AC433FF
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C670216C8
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Aug 2019 14:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrYhH3rN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfHAOki (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Aug 2019 10:40:38 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44405 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731698AbfHAOkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Aug 2019 10:40:37 -0400
Received: by mail-oi1-f194.google.com with SMTP id e189so53986910oib.11
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Aug 2019 07:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lMIorutSigRsrg4omned8/nmJVn1wldn1bkA5AUwrBk=;
        b=TrYhH3rNPdi7isGNJ0LzScjk2/f2X96O/+LbT+HxKIwyWPgyQE4bv0h+k8eb1H45Oz
         OHVhd2IEg+DERF650QOlImEfR2wmnHdvcrHGfgLzeP8tH3+XjD4mrg3S3RYHv7363cBD
         Q4QiMBqdm5NK/2HsmHT8Ajwd+6Y70pYRKmH+9JxeJSobQouvLELtAjnfT5n7McJbSTJT
         UKVz2uUSvWdP8GIrItyIinOg58r5acvYjCMMEUlA3dkT6Kjs8x+RpHncVJR8lKbfG6nb
         5X+2XMhZjXA8FMvhC7H3kO97WHSw+oKS0sJYiwvf866oA1yEn6sJs7+PtiT4nYugfMit
         U6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lMIorutSigRsrg4omned8/nmJVn1wldn1bkA5AUwrBk=;
        b=MlBAc4TcE8WIO2UHlaHwRuaa4eV6D5e5vpvNIUgJbkBX2IuDM2X/lawIhug6WKAKYv
         KUJfTjDaesiWp6J8OK9+0OFQP8ZqKmzxbY7aehGe0fxnPjKs7NFRxpr/z9WDldfbIae4
         0u86vbqalaVAXJGE3IWRYznrNvJgE7vtoNGPOzCK3Tyx18vyVHvZ2uQcdgKIFFcIDhax
         JYFOyRhdJytrkBORqnjfqWQ05IJcQNvxpV28uX2PCDBryKeAR3rgWI0Q2K9e6B09Ctic
         4i2wKWxUFTxw8FADFnbYWW9fJt0VCclDVaWs+uxBPvQ4vuUIZaZtLDvtp299rmS/LUXw
         cIgw==
X-Gm-Message-State: APjAAAXgP/gKHCQ2+MW4xwZo5kj/IlW2rq4+NwEgFRJqFggkV0WAptxd
        JODOTQW7Wrt+RDOfkEkWwMjM0o56Fea6R+ZXbsE=
X-Google-Smtp-Source: APXvYqz5SyoZb7gOkY36wwdbcICgRVpMtWpNhUYNJ/LLPhQH4pDs8j5SeEADk+E1BJsioTvoNxmkgGKl2t79W6SaNOs=
X-Received: by 2002:aca:5410:: with SMTP id i16mr59875441oib.36.1564670436707;
 Thu, 01 Aug 2019 07:40:36 -0700 (PDT)
MIME-Version: 1.0
References: <CALOK-OeZcoZZCbuCBzp+1c5iXoqVx33UW_+G3_5aUjw=iRMxHw@mail.gmail.com>
 <CAF90-WiSA88hMQSsvDP=vJK=DhLQPzUN4JzX=OR88oFowqJ8gQ@mail.gmail.com> <CALOK-OdQwvLx8AACr8bKSbS=2Pa4NDwSC0UfcgedgJhc7keA_Q@mail.gmail.com>
In-Reply-To: <CALOK-OdQwvLx8AACr8bKSbS=2Pa4NDwSC0UfcgedgJhc7keA_Q@mail.gmail.com>
From:   Laura Garcia <nevola@gmail.com>
Date:   Thu, 1 Aug 2019 16:40:24 +0200
Message-ID: <CAF90-Wg_Raz=Ht3VNErx+FbMPZcn8z6_BosSFSqu5H=w_AdbZQ@mail.gmail.com>
Subject: Re: nftables feature request: modify set element timeout
To:     Fran Fitzpatrick <francis.x.fitzpatrick@gmail.com>
Cc:     Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Aug 1, 2019 at 4:22 PM Fran Fitzpatrick
<francis.x.fitzpatrick@gmail.com> wrote:

> How come we would need an upstream kernel patch?
>

I meant that the expiration configuration is a quite new feature [0]
that requires a recent kernel.

> It seems like this can be done in the packet path, but I want to do it
> outside of the packet path. Ref:
> https://wiki.nftables.org/wiki-nftables/index.php/Updating_sets_from_the_packet_path
>

No, the expiration time can be modified outside the packet path as well.

> I essentially want to update the timeout of a set element from the
> userspace `nft` command.
>

If the expiration approach is not valid for you, then currently the
only option is deleting the element and add it with the new timeout
value.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/commit/?id=79ebb5bb4e38a58ca796dd242b855a4982e101d7
