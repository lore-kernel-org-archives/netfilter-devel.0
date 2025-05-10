Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13B51F150B
	for <netfilter-devel@vger.kernel.org>; Sat, 10 May 2025 12:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746881545; cv=none; b=lFVolwyVpU57R17nt42a9yFP5be4tY2dqLsoDam8dxAutG/BxCdvx7fukRAOkEpyzNuBpAg5cCj/9aZoYqhw9YzdQJo710flq7TjFBfksV/XU4SWRib3N8+W7JBC2UFY+NhjKuUvCadUuXsUOdbvAUwcw94EW6+hdMh63UE2pfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746881545; c=relaxed/simple;
	bh=OVfzBzTM5p7s501tty3I4y5w4ys0SbvKw8vscIbcKm0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T5uHyfT5dGBB3Vo0yRCYvS05sSXTOWYE7gveDXqiwcwsC55aVBN2HcCMVNGYhb+hD+MpcJfLNKU3VOQ9iXvRS9BSBbkGAWNknaoSsbVw7lqDCGogv6twgHeuejvMCF8KByH/V6efIgKOlMkPkwo03qmfejN3Ngvt8qqKcna7Bn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KgPNgW9b; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KgPNgW9b"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54fc64e8419so2159177e87.1
        for <netfilter-devel@vger.kernel.org>; Sat, 10 May 2025 05:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746881542; x=1747486342; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OVfzBzTM5p7s501tty3I4y5w4ys0SbvKw8vscIbcKm0=;
        b=KgPNgW9bi+ylD2w9yM4miVzUI1/DYIk6uMfDHyk6xi1B6Aa5HKgA+L0qHy5EkntKK4
         QEdDXezCYJJhYB56bVi5rGckBiIPCYXfsEcnjH213D9ftuguIPdwqc3IJT/1/K5b2tPB
         AM2xjiK9BsYswzlrrJz2h8hEtiVRAZCYsM7VCJj7qrak6Sx5NXIE4A3rJjBMKFFzfzbb
         8/n5oeGSF9/g3FlbMBOC2ltHfboHbmVVZ4DIHNMgjbMZiNHcvWhJNZYXN86EbKszceqZ
         MdA8IhtBI7ifzV7IsjBOmFaYRJZoJu8h05f5qYD58Un6AqPhtFlLC7NpmuaBKUhaktkZ
         qnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746881542; x=1747486342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OVfzBzTM5p7s501tty3I4y5w4ys0SbvKw8vscIbcKm0=;
        b=VSxy67GRUIauPAKNZToPMbZipRsFS8S/lc2b5fTBLX040v3KXOMGchKV/RYNiv6uiy
         vLinCxaDE+uTTrddXbVWUUxlm1JVC3tarsq6neqqppVknu/4f57yZoWWHzSCflQybQOI
         3eo55xNVt1b0aIgLsDqcdvCkecAuPWIg6bdZ6ioyECq2Amt4OWYWNRJwuGo6afbTQYea
         qBdnt4vLNJZ4qDtx7nBKDQPyrkMfxLLRuUFGAivkT1lxTRazNgVO5L9T8xkOe4mAJhkZ
         fw2o5RBypROlpMPDoLgTKLMoRM7vEpmuG6QFfeMMIM/McUKcwdVulgNofZ18wFMw5dL7
         pBUA==
X-Gm-Message-State: AOJu0YwTsNL5B5gVxCHxouh/Z+6IMte4EiIOOwMYjusWhNm9RYFg0paY
	s2/uS7L7Nu6e1z8hPGxlXjxmIcHKaC6OlewwfVVJQqdx/cp9FjysGl7stccvCoxeB4Rdora99Fi
	dTz6Sahu9NmLwDt3sxuLauamNvaQ=
X-Gm-Gg: ASbGnctaCkGeuXjNwo4xuQdhwOBfovSImqJlFV53UoqHeNLnKv6OgUtcu5vLcqAq/C+
	jC6LKxyBDVgON7RNrqfQoR5x5rHIMOeK6vxrxA5zCtNrpQ9u8BM4TFHV4S2I1645ToffXe0i/RM
	e8h0cclvAXwehWNCZWqYVyOCfQ/BN2CO+v
X-Google-Smtp-Source: AGHT+IGKcZoSggAewKC3+ChEFJzbYUhM40pzRhTK52HS8sJtLkzmVbpuzSn0yLK7qhRJOJm/xCTjtRrWHkoypGDaaXM=
X-Received: by 2002:a05:6512:3127:b0:54f:c404:d273 with SMTP id
 2adb3069b0e04-54fc404d2cfmr2846728e87.26.1746881541538; Sat, 10 May 2025
 05:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJV_tgbKEHTn9T+AZSduNe4YdxQxe8aeriteuYzBmjUm9vNnyg@mail.gmail.com>
 <aBpv9rBirbFkpWvB@calendula>
In-Reply-To: <aBpv9rBirbFkpWvB@calendula>
From: Monib <monib619@gmail.com>
Date: Sat, 10 May 2025 17:52:08 +0500
X-Gm-Features: AX0GCFtAg8rpjxzDRDGI1wI10BM0xQo9GcI0BegIQRjCrAgIUoQp7cMFwHJQbp8
Message-ID: <CAJV_tgYPKU__gJpfgV+7uVzMGuDk-NE5GWTfBgr+2OOnyJtuqw@mail.gmail.com>
Subject: Re: nftables netlink cache initialization failure with dnsmasq
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

Just wanted to let you know that I forwarded the issue and your
insight to dnsmasq, and they have applied a fix for it.
https://lists.thekelleys.org.uk/pipermail/dnsmasq-discuss/2025q2/018168.htm=
l
Thank you so much for your help and for pointing me in the right direction!

Thanks,
LoV432

On Wed, May 7, 2025 at 1:24=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
>
> Hi,
>
> On Tue, May 06, 2025 at 03:57:23PM +0500, Monib wrote:
> > Hello,
> >
> > An OpenWRT user here who has been trying to set up split tunneling
> > using https://docs.openwrt.melmac.net/pbr/, which uses dnsmasq and
> > nftables, but I am having some issues.
> >
> > I am encountering an error =E2=80=94 "netlink: Error: cache initializat=
ion
> > failed: Protocol error" =E2=80=94 which seems to be produced by nftable=
s. This
> > error message was introduced in the following commit:
> > https://git.netfilter.org/nftables/commit/?id=3Da2ddb38f7eb818312c50be7=
8028bc35145c039ae.
> > The commit message says: "cache initialization failure (which should
> > not ever happen) is not reported to the user."
>
> This commit you refer above is exposing an existing issue.
>
> > The issue starts happening semi-randomly but seems to occur when too
> > many DNS requests are made in a short period. Once it appears, the
> > relevant nftables sets stop being populated by dnsmasq.
> >
> > Here is what I see in the logs:
> >
> > Sun Mar 23 17:52:24 2025 daemon.err dnsmasq[4]: nftset inet fw4
> > pbr_wg_xray_4_dst_ip_cfg066ff5 netlink: Error: cache initialization
> > failed: Protocol error
>
> EPROTO can be reported by libmnl with netlink sequence problems.
>
> Quickly browsing dnsmasq code, it looks like there is a pool of child
> processes that are sharing a single nft_ctx handle to handle events,
> two or more child processes are racing.
>
> I can expand libnftables(3) manpage to clarify this.
>
> Thanks for reporting.
