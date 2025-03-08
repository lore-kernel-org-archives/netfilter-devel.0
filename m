Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA4914B086
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 06:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741416101; cv=none; b=b1IlTjuBiKPcod/g5EAvbUGAEcRGwk1Bp3K6NmRvb0f0RV4PkK0aSKjqrzVU8iNHVJiUhNPlyloWIbLNg5182gPcrKi7DiiMeqMZWlZLhgfGjUwHK5byUp9YHGnVIpc5kOjrjtGsaMD1dzDwGAJdXmGqDrrvS16EJuW27c4rllU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741416101; c=relaxed/simple;
	bh=mjXPEAUzfnISY0ZB5Qdk6ZqkNFSViNSHUixjtjhaCsM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZhSVHFqHUmSoBJWANtq3as1g7pvzrMLIB295AjJnbhJxsrondaCdwzsiUg1gJxPuHXUC0QxHie7CubBohcX+qhL6pH+n4Svbwmi95bHisS3hzjFg1eZ/cuw1I0wvNWGW9nlZj1DA4Ss+EMFKFOftGVPrpquExm8B+4jWCriCW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tdYqKpo5; arc=none smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tdYqKpo5"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4751bec4449so14534691cf.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2025 22:41:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741416099; x=1742020899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjXPEAUzfnISY0ZB5Qdk6ZqkNFSViNSHUixjtjhaCsM=;
        b=tdYqKpo5mktSxKY1FOn2TiNPTX/sYR8C0/Smr7KIz89eGpSvzxW7jtlR8SQ9GeOh/i
         Q8JRRCh6OXkQIuJWyEfNmugd9CuexhJbII1B85AubppeGD28u8gJVU4oRRSyHnaSgY+i
         XwQgXorFsprEO68HuDnGIBHRbB7Pno+R4WVVZE82OkPhbiC05fDJGIxmsbyS7Zb2M+Lp
         x7iVvm7W8v4VT4GZGxgCOZNcpitU2DewCeIEz5J1gesXKl7w7WURMsFoOMUs8WOFNeHH
         2Iej9yyXfqc1gfzVZ1FdcRrllRRNXi50icRRwnDvBk/6O3kh3ti03iwADk0OZJC0Xs2O
         rdXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741416099; x=1742020899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mjXPEAUzfnISY0ZB5Qdk6ZqkNFSViNSHUixjtjhaCsM=;
        b=JQgaP4g/yVpHzzlqvxvUCB9wGV+ehxg3Emr0vIrkgo5sUK54s1GNsQO0oV7L9n7baj
         aRrA2ftracwIfqym2C4MCcMaPIsxyuZRpmFjXBzYP+OMlMeSBoTF4vxa1J64IIkqfVn2
         aABiXKxxSgfQgm8sFeinSn6mn7QXve8AuS/oub3OSjW27LHRrmUuLxQQfD7VJIYiuASL
         62XZJdwAPWQdYnQWbRdZdWHPfRC2McCBGa65GGCjpP81SyW/yqqa2rOF7d7+UkoHOSct
         B8qJuA47rp6q02pXjBHVJDG8uGDyf19t3IOQxz/JBWMnCfGY3LWWDyYhSDIziOImBXOL
         LXTg==
X-Forwarded-Encrypted: i=1; AJvYcCUTL5fwci/NJh8E7VUVx69eupLZIhTMUpepGNunJp7FOOJ1xprsENMvTeSF+OaLzOpMB7xuTITcJd37ksb4ebQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwU4m8U+csVdoqr2Ak1IuX367V9otC6NqC96X7ZGW1K4JUVyPsY
	EPGvT43RaWzMNOrIDuG/dfNe8XrJtZSUcTmfHX+svft2G7TVrIgKw1XpAA4stDe+CFy5uHCRMv2
	1/krMc/X/b9R7dzLcBpnIJ2p9VWWmgNYXAfok
X-Gm-Gg: ASbGncsQ3Rt/4cNTAEepVRJ2QNGYueDyATNPK+shK+/GE+Rl8LFgZ/YXaJ7APdVSZEU
	6Kz0sKSif2u1ARFoDyG+XgPNROR9sIXkU9j339seo0NmYdMzIqUhXYYsC4adwiKGwHpPD75kwC5
	75Tg1368as2GkRbzM6sIqgMXrzdAhKED+wML4=
X-Google-Smtp-Source: AGHT+IH0eaLgh+XEDCWC3SYaInWPdIV9YE7cJpJB2zom7UsiOlycuB30zhF8t9x6msXH3oGPL8h6ICGxTYOXbXt0l5c=
X-Received: by 2002:ac8:5d52:0:b0:476:7327:383e with SMTP id
 d75a77b69052e-4767327436emr891981cf.13.1741416098891; Fri, 07 Mar 2025
 22:41:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250308044726.1193222-1-sdf@fomichev.me>
In-Reply-To: <20250308044726.1193222-1-sdf@fomichev.me>
From: Eric Dumazet <edumazet@google.com>
Date: Sat, 8 Mar 2025 07:41:28 +0100
X-Gm-Features: AQ5f1Jo-nG_abX2mxVG0F6FyAQP3SKkSj2fRU5w8sH3E0_u7XuD1N8-7npTR7nI
Message-ID: <CANn89iLV6mLh8mWhYket7gBWTX+3TcCrJDA4EU5YU4ebV2nPYw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: revert to lockless TC_SETUP_BLOCK and TC_SETUP_FT
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org, 
	pabeni@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, horms@kernel.org, 
	corbet@lwn.net, andrew+netdev@lunn.ch, pablo@netfilter.org, 
	kadlec@netfilter.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 5:47=E2=80=AFAM Stanislav Fomichev <sdf@fomichev.me>=
 wrote:
>
> There is a couple of places from which we can arrive to ndo_setup_tc
> with TC_SETUP_BLOCK/TC_SETUP_FT:
> - netlink
> - netlink notifier
> - netdev notifier
>
> Locking netdev too deep in this call chain seems to be problematic
> (especially assuming some/all of the call_netdevice_notifiers
> NETDEV_UNREGISTER) might soon be running with the instance lock).
> Revert to lockless ndo_setup_tc for TC_SETUP_BLOCK/TC_SETUP_FT. NFT
> framework already takes care of most of the locking. Document
> the assumptions.
>


>
> Fixes: c4f0f30b424e ("net: hold netdev instance lock during nft ndo_setup=
_tc")
> Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>

I think you forgot to mention syzbot.

Reported-by: syzbot+0afb4bcf91e5a1afdcad@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/67cb88d1.050a0220.d8275.022d.GAE@goo=
gle.com/T/#u

Thanks.
