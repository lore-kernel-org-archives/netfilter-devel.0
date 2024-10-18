Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322DB20E312
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729276728; cv=none; b=dOcFwPhhYZ8IIFZWUBbp9mBQ2kwoAXbFFdCdWBO0sh+9/0YtWFduB22es282geOiK8UfkkPWX6sRwYoIkEseFlekvBa0HKonF3veqZKQHeX+LpZ0egqXREE6sHJimIZEbY2gWFlsAZNnu/oQc896g5CPco3Br8T3MN3EjX/rTmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729276728; c=relaxed/simple;
	bh=Swzhb2Jxm1J8ZD9jTXR9u7yjXCpY54KteJNUVhgxsYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GXgdLedbUB3JeNwubq8qicVu2Md5vszPWspSy/Ns7Vji1wo62ya4pS7ubT8HonCJUrXUdC68QaqPpGbyYKOIWfUTacSY9AVZvKEVVllGIUeu28HjD5qzw5qppbsKStFqB5+liH7h+ja9zHh8vygDFGa0jw8aq8a42ga6vPIhGQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geexology.com; spf=pass smtp.mailfrom=geexology.com; dkim=pass (2048-bit key) header.d=geexology-com.20230601.gappssmtp.com header.i=@geexology-com.20230601.gappssmtp.com header.b=WA25T/KX; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=geexology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=geexology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=geexology-com.20230601.gappssmtp.com header.i=@geexology-com.20230601.gappssmtp.com header.b="WA25T/KX"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5c9693dc739so3074177a12.3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2024 11:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=geexology-com.20230601.gappssmtp.com; s=20230601; t=1729276724; x=1729881524; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/kC3uEtiWpt0XXkBYF58wCw+I1EwJFrFsRCxyk8DcBc=;
        b=WA25T/KXDzvnQHwUvOTrJ1P01zhBBekWAXHqvOlYHN6r0a3e6GCHDuaJl6nkYwgUkK
         M31ImRh8YAUCenxbMW4O6OqxKU907SMBlBZyASgYtqw35I2zgBXarWtgfW+KulI7JvBg
         avONv4rRczYMpMdGDylQ4NvbPVOV6C6ZIYjLEzx/wYrO5tkV7QZYCNCXnQ3yIXTclPWA
         UZN/hx9TvOuVt3O1Khocud7u5aJQHHuvPVHFAOJigDcaDaG9zgiWLI7N4ngCAswBSIZW
         qIb6cPBU6t2ZQmSkuH7ciHfaZCkzy9HPhmdeF4T1f2d5QkaiZSL7jOMTgxQmWfHScpVC
         ykdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729276724; x=1729881524;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/kC3uEtiWpt0XXkBYF58wCw+I1EwJFrFsRCxyk8DcBc=;
        b=ma5jfV+WP4tZiQA672QPkqTT/UH+gCELcg26pTmFp3XsJOgi7c9IFsQEjsh9NkgOd2
         RB9XIO0TCpEe/0L9JBX20ppXIQR9yhdYXUUFtIn968iY+sWWCzI7r6qCaCBnPBBFQY+5
         3Lnw2AYXTt+U61PK6mdHSVBgrzjHzM9t8cZijOAPBY86/BcG61wyf5qGbfpeO8pUJfyq
         pqIdN7DckD4Rr9v40SBaRmbVh3yK2/4VBlYOnedYQx0TQbK04jt127+Yq4OHS04bKAhG
         +vATbNyXUHMVfVQuwuLYd+b5munuD9xQZhjNOjxEdKg12BTTUdYgC1dezW9rekqatRlP
         F0PQ==
X-Gm-Message-State: AOJu0YzC4YD7OQIvPecpoJBOBT9206bTjzTCNk0BQ84pMq8le6pXKdLd
	B6YY/AgOOv4jSrCF81oXPU8yM8NEQQYxyKUZ9QxlZoUmZoS9XT09gCIQd5cttIFiQVdXSRjgiNd
	+6GJwrXnE0gkWBCBSAeH9jlfJ2epN962xGnoz
X-Google-Smtp-Source: AGHT+IHnlYMA4P/ugg4z7+qwj6bBUv4mkqX7MbWw8dThLKBcII5wd2cnQrPZyglTIhCwX2zoFtEDkbWaR9FA6gnH8n8=
X-Received: by 2002:a17:907:2cc6:b0:a99:89bd:d84a with SMTP id
 a640c23a62f3a-a9a69a68f50mr329829566b.25.1729276724351; Fri, 18 Oct 2024
 11:38:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANPzkXkRKf1a6ZvOJU=m3NwW4B0gQnQSRggw=ZnK6kBYmqLtBw@mail.gmail.com>
In-Reply-To: <CANPzkXkRKf1a6ZvOJU=m3NwW4B0gQnQSRggw=ZnK6kBYmqLtBw@mail.gmail.com>
Reply-To: fredr@gxize.net
From: Fred Richards <fredr@geexology.com>
Date: Fri, 18 Oct 2024 14:38:33 -0400
Message-ID: <CANPzkXnY+8h+_z0Yz2e0_b05-BNbd-1XMuMLAeCbxpTE4=2L5w@mail.gmail.com>
Subject: Re: strange error from the xt_mark module for kernels 6.1.113 & 6.11.4
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Aha, I see the patch for the xtables typo, will keep an eye out for that co=
mmit.

On Fri, Oct 18, 2024 at 1:31=E2=80=AFPM Fred Richards <fredr@geexology.com>=
 wrote:
>
> Hello,
> I have a homelab with a bunch of rocky vms where I use the elrepo
> kernel-ml kernel, noticed this morning an error with the xt_mark
> module, saying it doesn't recognize the --xor-mark option ...
>
> E1018 15:18:11.083644       1 proxier.go:1432] "Failed to execute
> iptables-restore" err=3D<        exit status 2: Warning: Extension MARK
> revision 0 not supported, missing kernel module?
> ip6tables-restore v1.8.8 (nf_tables): unknown option "--xor-mark"
>   Error occurred at line: 11        Try `ip6tables-restore -h' or
> 'ip6tables-restore --help' for more information.
>
> I think it has to do with this commit but I could be terribly wrong:
>
> ...
>    netfilter: xtables: avoid NFPROTO_UNSPEC where needed
>    [ Upstream commit 0bfcb7b71e735560077a42847f69597ec7dcc326 ]
> ...
> It's only those two newest kernels with that commit, if I revert back
> to the prior version, the application (kube-proxy for kubernetes)
> operates correctly.
