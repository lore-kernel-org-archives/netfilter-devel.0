Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9CC5C3A59D
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 11:14:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBC7D22CE3
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 11:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JrjSXx0x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731777AbfHVLOx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 07:14:53 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]:45004 "EHLO
        mail-ot1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfHVLOx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 07:14:53 -0400
Received: by mail-ot1-f49.google.com with SMTP id w4so5046922ote.11;
        Thu, 22 Aug 2019 04:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Cq7ZUCbmYeAgyJFVs4vUQGwvTqOF2k2OwKjIXe/c/vE=;
        b=JrjSXx0xcktvgrVq4OGOQPmdPRGyo2vwpdrCtpkU+KkJ8wBPgGGu3r/48y7qu4s0qn
         D40tPPIjhz/A+4jIuw10Ea7ZQW/qkmJoSJ0RVw0PrPa+JRKQ/bQbGqEV/S4B8xyRGag0
         ZSprCcUK6uygx2E9j7XzZq9/JnL9tCDf8f4GzAiXr3HAAZkUjfBJ3pF7WAW8bRm1x5Nd
         lPFyeGJrjPwaSCU5JeutQyBhcsD9gOEWbG2Z3B36XR2GBI35zM1fMLmapXE8/2EjS8Fp
         nu0/LBDC5Pv5WFsMfoVQ2wnf74Vn1kU6MP0mmL0rYJGIKnbjnBQ+2OosRpcPxCJNrccv
         0tmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Cq7ZUCbmYeAgyJFVs4vUQGwvTqOF2k2OwKjIXe/c/vE=;
        b=WnI9j7i3qej8xQyhhCkIi2Cnh0SGzm1sJ1JDZddc95nYdKbqKQl8oJhBlw0CpLj/ck
         d44/Au/xRrIK3F7CIl0Q58/wdFPbJDztj3q3hyrJr6uk+eG/fZUVR3vW9i2sKh7R7wld
         n2k9RrdL1FDj3a0vUhYIg0p8wVZnqn0vKLN0n5U5mmigiC/mCdAqzLcOOF6ASMWXeN1r
         dWyXScgePaZvSAsUp7aoZLe6ZIJJ6WErRjzarnJcdhAlkI+7wV2AQA1IKZ0tCRxqHPFY
         W5wUlmUFkZnIIN313rPplj5jh+DOpJPnK9fvcCfiaPUz7V016410YOoMpM0mQgbEf7nq
         30kg==
X-Gm-Message-State: APjAAAVnCGwFVZ7fdvgs1SU7vOXDvC/7TpLQQnHrxyLI3g4Wbtd4Ge5w
        fVobWxeHQ0RCRzrsQqFntpmUv2bS4dGTz3kH0z/BeA==
X-Google-Smtp-Source: APXvYqx1HWibX5BAVQ66rXONckh7+H3uxQ44ilofyrLsy15wSFbFfDz4HfY/scdX9AUf9DDUkI7Je2TKtJprdLngUZA=
X-Received: by 2002:a05:6830:2055:: with SMTP id f21mr3863210otp.53.1566472492205;
 Thu, 22 Aug 2019 04:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <877e7qzhgh.fsf@goll.lan> <CAF90-WiPQgD7wftDxz6sT+nfH=bSRZiUJPKqBeUJRXhfPOkYsg@mail.gmail.com>
 <20190806173745.GA6175@dimstar.local.net> <CAF90-WiOo9wYWxJwAFcyjdU7OB1vgU9e=-QvDZ-vNJ1tcgmraQ@mail.gmail.com>
 <20190819040944.GB10803@dimstar.local.net>
In-Reply-To: <20190819040944.GB10803@dimstar.local.net>
From:   Laura Garcia <nevola@gmail.com>
Date:   Thu, 22 Aug 2019 13:14:40 +0200
Message-ID: <CAF90-Wgt9zBSi_as1vOsisegVFYSBHWSQwv5n_cMyEcFx3wcYw@mail.gmail.com>
Subject: Re: meter in 0.9.1 (nft noob question)
To:     Mail List - Netfilter <netfilter@vger.kernel.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Duncan,

On Mon, Aug 19, 2019 at 6:11 AM Duncan Roe <duncan_roe@optusnet.com.au> wrote:
>

[...]

>
> *** I had expected or at least hoped that an element's expiry would revert to
> *** the timeout interval if it was re-added, but this doesn't happen.
>

You'd have to use "element update" instead of "element add", but it's
not supported yet for this case.

> Was that possibility discussed on the list previously? Not having it leads to at
> least 2 undesirable consequences when watching:
>
> 1. Frequently-accessed sites drop off the bottom and re-appear at the top.
>    The lower part of the display would be more stable if expiry times reverted:
>    frequently-accessed sites would stay near the top while others would
>    percolate through.
>
> 2. Counters reset when these elements are destroyed and re-created.
>

As a workaround you can set the expiration time manually until the
"element update" solution is in place.

Cheers.
