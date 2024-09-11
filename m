Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C5A3FB1B
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 07:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726041029; cv=none; b=edY9xV+0jajnwu7QCNlvPh5yn/IWJaUC7Kw4AlLVoiPAlDbQgNT82T0qXjPcu5MsMM0U9SdN9oWCorwLEtHgWfYqDtOW7Z8Z6GdysPZ9PAP4KZLIx9CaKt6IZ1fnROa2O1b1gr2S9spUIVrZy0NB0O0hFrb0RbKhPK+SznLRiRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726041029; c=relaxed/simple;
	bh=IlLM9Wz0CWb+KaKLt/GDT8JMal2iFFSY5t5ANl31WlE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZcJic9Ac7LmMj97WEgbYbxfNWPIIBhd65eeA64KcKyWNuGky9eamfjCFsRMZq/3XBuT1uMMwg6ocMLnZqXjBKUZf0uq60umr5mxu9IT7VZbtEFg6x0LMItuIBD+uXqQleID15JdroPvvse7AbAWEKgjCNOcLPTw9Hp35BFZUFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WmseD+hk; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WmseD+hk"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-42cbe624c59so15168625e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Sep 2024 00:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726041026; x=1726645826; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D4gkda1J12FjRLKlh4xHlPlQg3l2otXO672c7D2FYWk=;
        b=WmseD+hkyvNgJV1qXnYzFcyN2d/EkgYOHxX99qQFJGRUWdUDERWNTR2CBNAwJtZP89
         7z4uqDl62gbaDh/mDNe3h5sbvg20TT453qNTNQ0jn/s4hRKWoVg8Kzq5YKy9JM6n5csy
         b+2kyYslhkhnDFmAjWn0qN5g+/bV0jRj/hRFckQuBiLuSX1W7mg7i0HxX6ZTJW+DMceD
         yIW4wYge4Mb523+Hoo1tNiCL1PhSiquyOkdI3ILYXIIEXeR4IPWpvxve9vYPaqadLog7
         3pBTXgNrXwgetAFSTN4NvhwD8QoYn2wGRTNDLf9Qfm14OA6ZyTIwNtKgXXFRa1n0jW9g
         cyiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726041026; x=1726645826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D4gkda1J12FjRLKlh4xHlPlQg3l2otXO672c7D2FYWk=;
        b=fJbGkj+fNVH1x/B+vrTHLjz9D+gXGMTofgC59FNn78CEZW8KZd7Dv5xv30yvinWj2Z
         8sh+5XibksbdvnWfCP02gJLIuW57ZNH/aPEl8CntdNTR6DUBZyvhzxiF+/DzFnjzrEmE
         KsVvpvR+5rWFWIBbiYYT/Dj0KwrADssEL/Z3jq7PobAzNWeH2WyhKumVm5RAO1dcNp/z
         uBntahW7PVVBPTUdQelvsTk1nzHjgAZZTdTOyiXFwjQUJSPZ6+lPBT8IQm2OgtotwuL+
         E1gOD6cCpjkytsvw0+UZzJhgkdWjKcpIi0hAJYYqga01VaEgyXMEc7aBkn/QJOKxFNgp
         YcCw==
X-Gm-Message-State: AOJu0Yy+3e97wqFzvLwd4wEPC/ICX+l4uoFhQfTOGOu4Mz4lnOEE5+K1
	ekBB8oiYIvi5NZ6xam5FeaDUPX6ojJX1QlnEKw7VNnNazLBfSuTfXs7bAnlud8BeKwbMJ4UYTWl
	TXhvlSNprEm0C7vlXbRbldyuzjnlrjB4Msa9g
X-Google-Smtp-Source: AGHT+IGSHqX7b35pE3/ArQdoLmw5Gk1qS6f8PM3gX3Ww5ReKf7elTZZaAKBOOhlTFFawOYan+dFPaWPLf7DJ6Q30mmM=
X-Received: by 2002:a05:600c:46c6:b0:42c:b9b1:8342 with SMTP id
 5b1f17b1804b1-42cb9b18468mr56074525e9.19.1726041025645; Wed, 11 Sep 2024
 00:50:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240901220228.4157482-1-aojea@google.com> <ZuC5GtQmVHJZaDxJ@calendula>
In-Reply-To: <ZuC5GtQmVHJZaDxJ@calendula>
From: Antonio Ojea <aojea@google.com>
Date: Wed, 11 Sep 2024 09:50:14 +0200
Message-ID: <CAAdXToQzpQidf1E8nyxBiXv+-SmVvLbvNj2a1HjfP4gMsJ+hSw@mail.gmail.com>
Subject: Re: [PATCH] ksleftest nfqueue race with dnat
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 10, 2024 at 11:24=E2=80=AFPM Pablo Neira Ayuso <pablo@netfilter=
.org> wrote:
>
> Hi Antonio,
>
> On Sun, Sep 01, 2024 at 10:02:28PM +0000, Antonio Ojea wrote:
> > The netfilter race happens when two packets with the same tuple are DNA=
Ted
> > and enqueued with nfqueue in the postrouting hook.
> > Once one of the packet is reinjected it may be DNATed again to a differ=
ent
> > destination, but the conntrack entry remains the same and the return pa=
cket
> > is dropped.
>
> maybe this patch is not your last version?
>

It is indeed not the last version, I just wanted to share a reproducer
of the issue, I've tried to attach it to the bugzilla issue but I
couldn't, so I've decided to share it over the mailing list.
I'm still learning the development workflows of this community so feel
free to guide me and correct me if I'm wrong ... I just replied as
HTML before, sorry :(

> I need this chunk for ping ns3 to work:
>
> diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/t=
esting/selftests/net/netfilter/nft_queue.sh
> index f754c014baa2..1720a49026a3 100755
> --- a/tools/testing/selftests/net/netfilter/nft_queue.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
> @@ -495,6 +495,7 @@ EOF
>  ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=3D1 > /dev=
/null
>  ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=3D1 > /d=
ev/null
>  ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=3D1 > /d=
ev/null
> +ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=3D1 > /d=
ev/null
>
>  load_ruleset "filter" 0
>
> then if I comment out this new test_udp_race (doing so to make sure
> test still work), then test_queue 10 fails.
>
> I think maybe you posted an older incomplete version of this patch?
>
> Thanks.
