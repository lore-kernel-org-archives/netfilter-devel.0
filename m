Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5C713C3F6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 10:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755686767; cv=none; b=mKez+s4ENW5aaR++2brgt5ycaClLpG38zNk19CbV6iIJri8UWF3L8mSBIY9z+Y/8jPogfPjld4IOpIXJREVBNZPX2KTMYiTu7pEdedDS0cwpiUW9Cj9kSnX5nMGJYs0SYbMbJ6uut5NnVDtFQdTmXA3RqwRgpKFv4p3D5Ndf+sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755686767; c=relaxed/simple;
	bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PC5Qq0+gW6mWftcvSPDe0BvOpF06SKtG0EyRhbhUtbGX5MtLquEWW9F/aCnTY2NsrTLlNZgO0z+ncaficLdCAhLX9tsnkWJGQiub1Moop+rVET7zTgxoJA46rICHuQRSLI0/w7odxOOjHkUvvE9ia6LESRuymCjLLbfpH5zWdhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Co8OJWgA; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Co8OJWgA"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b472fd93b4aso4066517a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Aug 2025 03:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755686764; x=1756291564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
        b=Co8OJWgAcDrYJ0CyrTpBTa4QFaWJA/UXQ60iKWZvaB+48GWb7YDZkuqYINSGkm0uIh
         ZYXB/1/0Tox4yTgl7PAOB5auKESusYPvX7nPMjjVhmW52s1AVNACCbtT13QaRXH38FhC
         xZYMsIUNP3rnX9lupsBneDOUUij6WTTuNR0vjOk3bTlCFKHfKLLo4Se+Zk0Az2jZPKYZ
         89qwkceSJ63MV0U52UZGugtikzmhBleYxT5X46BJ95PXkC5HrytFkEEuhgi1L6/2wsWk
         8Ax1EW8XLAMY2muWjJvXyU5aW83Oo3g47JQIHVj+U42VncmORoQQi0GFxmFGkSvAvwok
         JpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755686764; x=1756291564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Me8tP3A/Dq4n2o7fv0IO64KsodsWLaH93wYg8ejh9A=;
        b=vOftIvNSJfDRlXTirNDALIGtqMO6z8rx8NmDjrY4PD9VRxGtRFXILFFLLxcZupJ9yF
         zfqCLPHgBtYFOAUq5pHqvfD/E64bEuqjYdvn8oH4Bpg5QeF117/8HsItcqjq5u8SJgjd
         uwQgpZcdVEgQJ4Qxepp2yyaVAbqMnwLynkb+t4jSBA5MeyWDQqiWqRJ6H/li5Ser2Gj9
         prEGboPy3a89n/MJPUrib53RUFrwrFUdo9fyTNtVpk3ldu/oQAM6EV7pMsyfB6TG60xv
         SHS5pDGsMHoc4h2FBJ1ve5tomHK+QVa8s3bB5J5v1OttBWFpLYoAUkSj+Bmiu4lAlKg3
         ByCg==
X-Forwarded-Encrypted: i=1; AJvYcCVVuAPcadTGi8AdcPkid1pic05YQfhAQuxHYtImmExVOozJmZl3FIwbnm10QrzjL9vXfqJ7rAgZytneDfGyd/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxE17SSSTaAm2oIWxJ4qqSU0V2q8ttnE4jR3abpvCxkT/bQ2uJM
	x91NKtBwvi/FRZNMtLMpPmGjqHuEWiMh/JczkoK4j3PCBKdVBMIz6LTBVTDTjAvnFqRy8bBmRLi
	E2SB5MlnbhlfGq0PRYmAWvCTOSydfCsQBX8GhFu8e
X-Gm-Gg: ASbGnculucum8Lc7wBHrSTPvwAA1QHnYietOgI5998HkbCjmnzqpdC/XSfzrRvo3oPg
	qNfHV0HHL0sViSe2iQXEFWuUrG7/PE2ZGIXhP+M1Eoql5FHahCWlVne1RlmT008njjhO0ABLnv7
	Z1q8GIpF4Ab6SCrwkD4GzvPE2cAIGNME9e3U5gUUujb4IudgubWkIk3t29t2g55zqfPNZ1htYE2
	svgqI3wqbM3VcnrHJkJADIIYLbUEK68wbJSX06MIx0o7JhdtoZqzzE=
X-Google-Smtp-Source: AGHT+IEKtl2lrK5/2y4ZHW8BdiMqTimWqMJrLgdgwZdhWnnQOIhxftCfwBi0pC/VAlu+Wj78IDSFaxfyMArkbO0q10c=
X-Received: by 2002:a17:902:cecc:b0:23f:e2e0:f89b with SMTP id
 d9443c01a7336-245ef0bf919mr29929205ad.3.1755686763672; Wed, 20 Aug 2025
 03:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818154032.3173645-1-sdf@fomichev.me> <68a49b30.050a0220.e29e5.00c8.GAE@google.com>
 <20250819175842.7edaf8a5@kernel.org>
In-Reply-To: <20250819175842.7edaf8a5@kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 Aug 2025 12:45:52 +0200
X-Gm-Features: Ac12FXzOW9XPurRHcsWYD8YIbcfeKfyX5uwi588A3HEp9L6p1uEzyk061ngsuoE
Message-ID: <CANp29Y4g6kzpsjis4=rUjhfg=BPMiR9Jk68z=NT0MeDyJS7CaQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net: Convert to skb_dstref_steal and skb_dstref_restore
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot ci <syzbot+ci77a5caa9fce14315@syzkaller.appspotmail.com>, 
	abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com, 
	coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, fw@strlen.de, gregkh@linuxfoundation.org, 
	herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org, 
	linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, mhal@rbox.co, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jakub,

Thanks for the heads-up!
I didn't even think that this tag could pose problems for other
automatic tools :)

On Wed, Aug 20, 2025 at 2:58=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Tue, 19 Aug 2025 08:41:36 -0700 syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v2] net: Convert to skb_dstref_steal and skb_dstref_restore
> > https://lore.kernel.org/all/20250818154032.3173645-1-sdf@fomichev.me
> > * [PATCH net-next v2 1/7] net: Add skb_dstref_steal and skb_dstref_rest=
ore
> > * [PATCH net-next v2 2/7] xfrm: Switch to skb_dstref_steal to clear dst=
_entry
> > * [PATCH net-next v2 3/7] netfilter: Switch to skb_dstref_steal to clea=
r dst_entry
> > * [PATCH net-next v2 4/7] net: Switch to skb_dstref_steal/skb_dstref_re=
store for ip_route_input callers
> > * [PATCH net-next v2 5/7] staging: octeon: Convert to skb_dst_drop
> > * [PATCH net-next v2 6/7] chtls: Convert to skb_dst_reset
> > * [PATCH net-next v2 7/7] net: Add skb_dst_check_unset
>
> > ***
> >
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> > Tested-by: syzbot@syzkaller.appspotmail.com
>
> Hi Aleksandr!
>
> Could we do something about this Tested-by: tag?
> Since the syzbot CI reports are sent in reply to a series patchwork and
> other tooling will think that syzbot is sending it's Tested-by tag for
> this series.
>
> In some cases we know that the issues found are unrelated, or rather
> expect them to be fixed separately.

FWIW if you notice the reported issues that are completely unrelated,
please let me know.

>
> Could we perhaps indent the tag with a couple of spaces? Not 100% sure
> but I _think_ most tools will match the tags only from start of line.

Sure, that sounds like a very simple solution.
I've adjusted the email template - now there are several leading
whitespaces on the tag line. I hope it will help (otherwise we'll see
what else can be done).

--=20
Aleksandr
