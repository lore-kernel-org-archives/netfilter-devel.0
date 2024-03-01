Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6041C7A
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Mar 2024 15:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709306972; cv=none; b=qVlwoYT3FIE8PQQ1fX7tpx4o8S+EoVvg6su8vRUJlC8lkwLRAXpT7ZvAJ+ZwoJp7QpI7KweSzHl/Hksb5dtu54WIO4MNIla64hshPTJ49k/vEslo+jw9F7Ll+4Tve1wrej/qLswagez30Elz3h6NTkxET8jrCdipsZQQqAd8TaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709306972; c=relaxed/simple;
	bh=UpbU7hO7PgZpThGtfOUVUaIkjG5Jg/+Nv9/mNDW/57U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vEiaiZCONAzBywO4wBBMHqZg7H9oOKkh2CprW9qUO3ZG2yf/131vxa20sfzj6RnB7GFbecKlVrLPgad7h5oBD+SzJ3zWdy2iXyZLTthBA/5i1ApO1GNFOPOAGSUSfc8/HFSGtYGqVvmUR5TEQus1tidB1prDIeT33immQHhs3Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us; spf=none smtp.mailfrom=resnulli.us; dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b=y/Ct6uB6; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20230601.gappssmtp.com header.i=@resnulli-us.20230601.gappssmtp.com header.b="y/Ct6uB6"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-563b7b3e3ecso3676406a12.0
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2024 07:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20230601.gappssmtp.com; s=20230601; t=1709306969; x=1709911769; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2MZ2yOTO+KIB8siKuGMOdBUlhOc6wSKQHzvOaxRX3JU=;
        b=y/Ct6uB6QO5j8G6f2bPb6YwNXYIzuJNLWxoeYPlpjHNrmJoc8ZuHRhN3bSkCNL795m
         P38GwsgUAQbhhD9JkicHvT37H3ApLU/Ngu9lnJb+N7pp8BNuFygp0+Pm6/cHLcqE/bsZ
         2h7sRgnY3Rxu2Kfb8gmvn2LhfCPr8QDAoL/qPW/lxA5XRecYBJc+o7TIG5T1qH9Q/7Ph
         87XUT2jtjyOUrptYcLxBTv9pTON441DGM0ktxZnfH22BRlWpwycU6JKkz7WHj1UdktLx
         6ISJLRK5K+fhwYarQKLptGwxg3bVXaSCl9zT/XGXXil/n5DtoidfuVgm99yU1Jv8yh2w
         iR/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709306969; x=1709911769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2MZ2yOTO+KIB8siKuGMOdBUlhOc6wSKQHzvOaxRX3JU=;
        b=KJKp0xJiyjxpCxGID3WdJNID5t45sQdHcbDCbysZs/3L3BcwcwCFZ0U0Ayt7/Bt+sa
         4BzD7zDFkUTIxPapN2YKLqafcAb7aiUIZVKbgZyXxVhk0FCPwiaAhspOdl90zYRFpEjY
         ETa7/GRdLfMaLgr/rC68PKS84jDs80rkQpBm9rFnyNNLVmhjRlhdmXwx6ySHL2KBmiZ+
         GWTHF7uncivxzkOEMAl4Y4A4qh+z2mXvZK8HQSwfxrLTehgHa7Deb0X7IcMn2DBnG6oS
         LYwcxdBFlWHW7gc1U4EnFNiCTrb6gVP5PODBAJXtWbNHR/X2eFRkgZdNpJTqbcZicDbJ
         QfcQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZlvFLnJUoQ6yIsbojcgEKlAyaUvzU2QIg0ifwThcElq4u2m22OMW03VTX7aJawSMK5fQDXsPktx+NPedcf2ihgei0dI664Qoty/YDHc7R
X-Gm-Message-State: AOJu0YzPvrMMDaE8LBsRKuyXwvbVdlSxgi49DYgErPsf2zMtZYeGaoN0
	kcFCij8NPET+RFW6YSVqFn+0ZRO2CL1n0G1fifEqcpRWSg5kzm4etksjFaIiFNc=
X-Google-Smtp-Source: AGHT+IGXmTvmpDOBogei2NKEGeBxe8GHXKdXl6gK0nD5jHjKOOE0e/RY97L7Ob9/n6gWA62fsQQ0Ug==
X-Received: by 2002:a05:6402:3493:b0:566:f67e:3f72 with SMTP id v19-20020a056402349300b00566f67e3f72mr131359edc.12.1709306969059;
        Fri, 01 Mar 2024 07:29:29 -0800 (PST)
Received: from localhost ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id fe1-20020a056402390100b00566a1b8614esm1579691edb.58.2024.03.01.07.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Mar 2024 07:29:28 -0800 (PST)
Date: Fri, 1 Mar 2024 16:29:25 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: Lena Wang =?utf-8?B?KOeOi+WonCk=?= <Lena.Wang@mediatek.com>
Cc: "fw@strlen.de" <fw@strlen.de>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"pablo@netfilter.org" <pablo@netfilter.org>,
	"kadlec@netfilter.org" <kadlec@netfilter.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH net v2] netfilter: Add protection for bmp length out of
 range
Message-ID: <ZeH0VdU-q_UyX0t0@nanopsycho>
References: <d2b63acc5cd76db46132eb6ebd106f159fc5132d.camel@mediatek.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2b63acc5cd76db46132eb6ebd106f159fc5132d.camel@mediatek.com>

Fri, Mar 01, 2024 at 04:12:24PM CET, Lena.Wang@mediatek.com wrote:
>From: Lena Wang <lena.wang@mediatek.com>
>
>UBSAN load reports an exception of BRK#5515 SHIFT_ISSUE:Bitwise shifts
>that are out of bounds for their data type.
>
>vmlinux   get_bitmap(b=75) + 712
><net/netfilter/nf_conntrack_h323_asn1.c:0>
>vmlinux   decode_seq(bs=0xFFFFFFD008037000, f=0xFFFFFFD008037018,
>level=134443100) + 1956
><net/netfilter/nf_conntrack_h323_asn1.c:592>
>vmlinux   decode_choice(base=0xFFFFFFD0080370F0, level=23843636) + 1216
><net/netfilter/nf_conntrack_h323_asn1.c:814>
>vmlinux   decode_seq(f=0xFFFFFFD0080371A8, level=134443500) + 812
><net/netfilter/nf_conntrack_h323_asn1.c:576>
>vmlinux   decode_choice(base=0xFFFFFFD008037280, level=0) + 1216
><net/netfilter/nf_conntrack_h323_asn1.c:814>
>vmlinux   DecodeRasMessage() + 304
><net/netfilter/nf_conntrack_h323_asn1.c:833>
>vmlinux   ras_help() + 684
><net/netfilter/nf_conntrack_h323_main.c:1728>
>vmlinux   nf_confirm() + 188
><net/netfilter/nf_conntrack_proto.c:137>
>
>Due to abnormal data in skb->data, the extension bitmap length
>exceeds 32 when decoding ras message. Then get_bitmap uses the
>length to make a shift operation. It will change into negative
>after several loop.
>
>UBSAN load can detect a negative shift as an undefined behaviour
>and reports an exception.
>
>So we should add the protection to avoid the length exceeding 32.
>If it exceeds it will return out of range error and stop decoding
>ras message.
>
>Signed-off-by: Lena Wang <lena.wang@mediatek.com>

Missing "Fixes" tag, again...

