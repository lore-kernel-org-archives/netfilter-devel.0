Return-Path: <SRS0=tNyb=UE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD7AC46470
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8854F20717
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jun 2019 09:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVQdKx/L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfFEJeF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jun 2019 05:34:05 -0400
Received: from mail-vk1-f174.google.com ([209.85.221.174]:34330 "EHLO
        mail-vk1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726690AbfFEJeF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jun 2019 05:34:05 -0400
Received: by mail-vk1-f174.google.com with SMTP id g124so140327vkd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Jun 2019 02:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mW9FDo+XQK6GaKpK+9/jAKR9HPgD06ssKQTCbjNovz8=;
        b=jVQdKx/LmgzBGqBYkmk/JvuceNJXFBuEYscBi+MTqu1sMdEzwJD1SWdubbvV/7ThTA
         rfEDovHE8TBQg1JxRt9/FNBfJ+1sXBQCz5ymoU8dP7Efl/XaVPWWuTvGRQYA9KuEGqj4
         7qzsVLfmunSJX4Gq4f7fuYHdG7kdA481gAGOmZTSA7SOTIUenOYHqQpcxtIvPq08KTYt
         tDa7gJ4htmx7hqlcHPGqxdgsSQbfSRUvFRsunydimET8wAJPbejaV0AlZDWbVYFXbgs7
         tnjFgslhfwRTsb96h0nXhgEwr27qRvBlvIqjebuQB8ZLzp5kmwdjYDI3mhftdNlgXSqW
         Usfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mW9FDo+XQK6GaKpK+9/jAKR9HPgD06ssKQTCbjNovz8=;
        b=NFJqJxj+DluH0zOUi5WBSXX2VQkpSkNdtMmsiCJA7u6Nd2AclZ9gYt1jLf2CHvI01O
         I9sFfziUCyN+D14o6Wv036QTzgJyErRVfLuLdW7yA1XWAw5riwzYFhlVjJozOBMe+dL4
         mxlTeP74PKU1w96eiAY9fnUpoPC2Tu8T1eiwXs/CsniOaGHdDYpofgGb4zdg0gJ6Vi9f
         rLSqZl/n2Ua5EHl1YUuRmd1IvapvfJ6I23xNww8WqT3jXQsXq+3i6RMgGykkDMw9ZFMr
         LNDaU/r41K6o6g0krdyNbbjiZrH+rnI85AzYxwh7XEOSw7OZwot6MND5vVBZIKYt+9Hm
         dkyg==
X-Gm-Message-State: APjAAAUl7IqW5k8L2q8BQoVPV/4HqnoQRhYfDsDlVfEWs9Fvdjrbgz9V
        CoCAQr0kLVRC6rMgvcN5IjgYLMSEA70U1wwEmy6t/w==
X-Google-Smtp-Source: APXvYqzgSfLJkVHNRszb0bqygrDw0u6YRzMrzoCVMTp2RV4VLjXvB2q8cA3DkFL80Cgq7vwRjU9LkTU5G5Wl5cPIxtI=
X-Received: by 2002:a1f:ac05:: with SMTP id v5mr14762717vke.34.1559727243864;
 Wed, 05 Jun 2019 02:34:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190531165145.12123-1-sveyret@gmail.com> <CAFs+hh4n3nY5WSFyChinVcGw7PNM6CghwWOdqxJuiM-xOTk0xw@mail.gmail.com>
 <20190605083537.nsfbwavpcnjugzzu@salvia>
In-Reply-To: <20190605083537.nsfbwavpcnjugzzu@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Wed, 5 Jun 2019 11:33:52 +0200
Message-ID: <CAFs+hh6bR5NCbgRy0msd+GZcmfgCb-7piHz4p9Pi1sfJHbjrkA@mail.gmail.com>
Subject: Re: [PATCH libnftnl v4 0/2] add ct expectation support
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le mer. 5 juin 2019 =C3=A0 10:35, Pablo Neira Ayuso <pablo@netfilter.org> a=
 =C3=A9crit :
> > Is this enough for you to test the =E2=80=9Cnetfilter: nft_ct: add ct
> > expectations support=E2=80=9D patch or would you like me to also send t=
he nft
> > patch ?
>
> Please, submit this too, thanks.

Done=E2=80=A6 :-)

--=20
St=C3=A9phane Veyret
