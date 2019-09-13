Return-Path: <SRS0=UCZI=XI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE336C4CEC8
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 19:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5CF92081B
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Sep 2019 19:06:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NAAMSHZh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728935AbfIMTGu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Sep 2019 15:06:50 -0400
Received: from mail-vs1-f66.google.com ([209.85.217.66]:45817 "EHLO
        mail-vs1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbfIMTGu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Sep 2019 15:06:50 -0400
Received: by mail-vs1-f66.google.com with SMTP id s3so19307409vsi.12
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Sep 2019 12:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=avTxG9uAhphGCxwL+jrrl8mMrHYmIieuQQsM9w0nSu0=;
        b=NAAMSHZhaBO5COns0ypAGmFuKomvQI7jWc94/UyN5Uq9jSTMtR/H8vN+ZAkcvQ5Q2O
         Zq/6CcRq7IHXcaGTEpkhN+ZpjDEcvMBanPhomIvBZrYiyHw3JJh5TkDHEOFp317WrW+z
         ocu6Iqt3G8bqEAb7lycW6Y6/+GMYnBUrSI2aet8pRhdUaHpPMVG4837MxbtNl3dGRQMe
         0LqtTvUh0IoXhM6ASxN9kGMULcJMCQOdBNJFTCdqp1PP6mkfz2IFFrhrPxctmFAT9EI3
         Uenla5qHzsZ1qe95l3lY8Spn0TQ+/rQXfEuNY9dpUZ9WAHPX4EZEVLegPjitfbFhUCQX
         +Z8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=avTxG9uAhphGCxwL+jrrl8mMrHYmIieuQQsM9w0nSu0=;
        b=nIjG7MMyW2f1IC89K53AlkDYiWwk1Rrw7mKh+TDuKpNxIqvce4q2FnanhUpaGWTS3p
         MqCHSwaBowOit94KrTVl4o/7R0hIRV9wwP0qeFudJaWW2R30xqSu2FkFDAdKecbaO7PD
         vhlAcq9YBdvN0ITg81DZQrt2C99m6lkrNvgvP/pgrcGhB47bcNHyU1ynC7jqAtsurpIn
         HBjIW7ZWRSS+Sko5wW8wwhgdeiGfATsemJXH9MW3Gum3j781f33hP8dKa2gxuQ9rSFNX
         WDpWQj2oQVpPwH8cViVqm5kZTZHS6BKOt57FtUJX9KJGI493JN5J+0rRf3qbyAaKYk3b
         yx6w==
X-Gm-Message-State: APjAAAUTnUOmZrhm7wVf+wFUoHjhEddthNSTEHElcNa5nRqrRpDrCsm7
        tnJ/R88iJH0uY1Ddb1dgtpQ+80/fARxywuORqbY=
X-Google-Smtp-Source: APXvYqx+/oPDIEnrJV7EhLrt0MzGwx3i7xGqxvyy7aCp1D7PThvLQN1j4yf9oRm+qWoBgXpB/1Wr2lpaVlPd3jtSnbQ=
X-Received: by 2002:a67:f419:: with SMTP id p25mr25291345vsn.203.1568401608737;
 Fri, 13 Sep 2019 12:06:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190913115658.10330-1-ffmancera@riseup.net> <20190913163019.f6obvgaiw2qr6rgc@salvia>
In-Reply-To: <20190913163019.f6obvgaiw2qr6rgc@salvia>
From:   =?UTF-8?Q?St=C3=A9phane_Veyret?= <sveyret@gmail.com>
Date:   Fri, 13 Sep 2019 21:06:37 +0200
Message-ID: <CAFs+hh6j4ZNCXNF3RxLoNrcb7JUJ06KcThkqwAyo+Dbydv+dbg@mail.gmail.com>
Subject: Re: [PATCH nft] json: fix type mismatch on "ct expect" json exporting
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le ven. 13 sept. 2019 =C3=A0 18:52, Pablo Neira Ayuso <pablo@netfilter.org>=
 a =C3=A9crit :
>
> On Fri, Sep 13, 2019 at 01:56:59PM +0200, Fernando Fernandez Mancera wrot=
e:
> > The size field in ct_expect struct should be parsed as json integer and=
 not as
> > a string. Also, l3proto field is parsed as string and not as an integer=
. That
> > was causing a segmentation fault when exporting "ct expect" objects as =
json.
>
> Applied, thanks Fernando.

Thanks. And sorry=E2=80=A6 I should have done it, but found no time until n=
ow.

St=C3=A9phane Veyret
