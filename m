Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB12FC43381
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 22:48:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2D2F20835
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 22:48:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=yossarian.net header.i=@yossarian.net header.b="CCh8NJUL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725983AbfCCWsO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 17:48:14 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41816 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfCCWsO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 17:48:14 -0500
Received: by mail-qk1-f193.google.com with SMTP id y15so1850632qki.8
        for <netfilter-devel@vger.kernel.org>; Sun, 03 Mar 2019 14:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=yossarian.net; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ugEKVdZsweH5ycpVD1Fy6rScy6AupTcYuPgVpU0JY+o=;
        b=CCh8NJUL2TxpHl3Rm9z7n9Jl7DhN8LDVaE+/pCpIyqAlv/qc30JefUMbqvdmHroYMi
         jpXktKxyge+KF7vjdqDOXm20y97YhVAeCORa/7GMx5cCuDdkbGPN4Q80ebf7lgatevIV
         YmLhfocYQd6WJ/i5RI3sBU171b0TEUQjMfgrDChKqVNGeTnHKUA2S1WdvjkwJrB+Lzfe
         kPp22HjPtzKr3qJOGPNyBfo7MHtx+y9kWF0d/BFawr2Mf4ZNNeXXdHj5wKusUEiq2aFp
         /kOzaeMmUOaqUC6BAtYWne2ogGKX1kqFetfGlNsiCwTGB2DBKMgNYj3B+P+Q7zmcm6Yv
         4dSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ugEKVdZsweH5ycpVD1Fy6rScy6AupTcYuPgVpU0JY+o=;
        b=AIGM9TnWsnkhli101ov5yvndkE1htiR5TamD/BI0IlFSq2GX6pwY58+6HSp57jJQ+y
         EkhYxUki9Zt86AEBtTzUlFBr8Cvq+w7Vh1io1CjIJnV2MfdZrX2pzcVimwjZyar5HO0W
         Yt5h7IO3WLNfVxD3x1+V9TqjXVoee9gRO5fYh/qzuzggnPW1eCHmYEdIh5HqDmr4nG7k
         kmZt3X84LNAWW8sprr/Gjle+34LLwLUH8XROrjtYSH31DT0wxaYz3sDOoOJSXLDmq+tv
         stbEv/58u+41O9HN6dSXzI0kkh1IDgwK5pYJnbWqN8g98dr4+B2ATGjXVoPBUaBvJ5oP
         vyAg==
X-Gm-Message-State: APjAAAUlHXmXSTsJQdcgrRaXyukWxS+eQQSDd2cIlm5Fom00CoGezIZu
        AZIxfsATdi38kFGze9kpM8UOlSVhUQA=
X-Google-Smtp-Source: APXvYqxRljQ1M+t6s51fmPCbH1FB7UHz5f+p+/ATN7S5bonUUc+xvadjpeZUZ/5pWVV98GSaZSkmGA==
X-Received: by 2002:a37:4854:: with SMTP id v81mr11496168qka.6.1551653292399;
        Sun, 03 Mar 2019 14:48:12 -0800 (PST)
Received: from janus (cpe-68-174-112-165.nyc.res.rr.com. [68.174.112.165])
        by smtp.gmail.com with ESMTPSA id c2sm3150478qtc.41.2019.03.03.14.48.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 03 Mar 2019 14:48:11 -0800 (PST)
Date:   Sun, 3 Mar 2019 17:48:10 -0500
From:   William Woodruff <william@yossarian.net>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] include: Use char* for arithmetic over void*
Message-ID: <20190303224810.cqj6eogqvfagvfo2@janus>
References: <20181222043948.GA3805@janus>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="rj2sb4u3wragoj5d"
Content-Disposition: inline
In-Reply-To: <20181222043948.GA3805@janus>
X-Clacks-Overhead: GNU
User-Agent: NeoMutt/20171215
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--rj2sb4u3wragoj5d
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Fri, Dec 21, 2018 at 11:39:48PM -0500, William Woodruff wrote:
> Replaces use of (void *) for pointer arithmetic in three inline
> functions and two macros within the iptables includes.

Would somebody mind taking a look at this patch? I think
it got overlooked.

Cheers,
William


--rj2sb4u3wragoj5d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEkOgaiEpmzctQWwiUYA1oMgvkWswFAlx8WaYACgkQYA1oMgvk
WswSSQ//dWpCKebAbQVgV1WTpwTJvTgwhjfeUibEEeX1XHKzZheOo88uoDcXsP8d
Ra0fBD2/k1q42hMHwzdeWSuHHKAsAXKkenyWZ41ANhOJ3yLxj4yt1Vb45yU2/qIY
StTcu5akTgScJukoKPENcYANkSnAcJ65UT48livyZQuL58MCH0V7Wpvd9Upb8OuF
LGASTKqeR7Buvq2kKpvoacGm4JBwMzmDU5qnRsOTLFlpkTKzKZ72myGjDXBPnnqd
TEFzYpOzIqN9tMoPznpBBaYO5LksSUdRikEarGYn+52ZzYaumT2WgbJZMbtBmNEG
H/sg/thMLSIHt3/5vfESU+IUZvT6lNoLWlhnIiRnMRn6sNkpw/8xvHqDxqlknjGP
HSKcfY0URVeWUlpivTw/XeUncDUsy7nz7F9bq/8Xblucr/rmd+W7tUx/id5KRDm1
mNL+Sj9629ARYjwwl5g05Vodt7rNFEQJ8ricoB3zHU1Bk4ztnlF3J9bMpvWG3x5t
xfsx+ehPkIm6sXgZDacFT0O4SfFiJ36ei4f0WB5hFyv2Li076s/Pw7iDSPGNgp/l
q9FPoBwJl09cHybh96txZNrbW35x+6goiIEvteMJ6G2dhmdKGRxHMriI4UoEcJcv
iNCS2bTmeU6TjBLqMLMLPHznKIW92ORfXKIeYn9vq6bN0EowZ74=
=/qwE
-----END PGP SIGNATURE-----

--rj2sb4u3wragoj5d--
