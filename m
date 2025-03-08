Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0410D383A2;
	Sat,  8 Mar 2025 17:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741453736; cv=none; b=XYj+BRwgcKP8Sv8H4jILYuxqmHT0G6go8MFenpIO3Z074mkRTBkuTGir2T5jULIHOprElQSpzrjbHC3l6wJxTe5zyJT/pe0W18iirgp43UlMGizbkZ1mX5GMzM5YQnIcY31utNWj7LDTB93ds5BU0ZjfqwF6Ik83H2xgFcxcofo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741453736; c=relaxed/simple;
	bh=YrA7wd8n7NLqEVAxegd9y+Av4QEBqHIaZpXSN7Muc+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DEF6dcvRyq34MaveM30oR+xHvIJEwr3jLDaN4bylEjNn+xQPXl6yfXFu7AL+uRgoN1mV3xI+NtZxOaDUK7Jcb39Q26yw/ifyj+1A7oTXi26NWqvm/GTLhM+GT3kcVjEoWrmNB6H5T3BMQofSW6QjvkjoEgUyagI3H/6FKe1J9Dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ENzzTTAw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENzzTTAw"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-224341bbc1dso23699175ad.3;
        Sat, 08 Mar 2025 09:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741453734; x=1742058534; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4IcMf84uhZ1TJoFOuLgOfVe7+B4onn10+WD0mzIT9m4=;
        b=ENzzTTAwRBwxma4dIAk3Xuti416AORrZnEtmJD7N8fsRX+HVZV882Kw774b8UP+8iV
         u6qhD69DmObqgC/mLyV9ZefdrWeeCGY1WaKzsMDHFe0s8mPOIdFt1tVFjbVpyvT4EuCE
         r9R3q4YblY8lmmyEA0BQKZYntBVlpL0XkRy+C/gky4q1F9ujIYFf72UzMB8x6c51haRT
         JmsocNEQ6jvgmke5ZmapC5OxnDYXS6p2ZfFy4kUV3QJyabJeQvo5PMi9nNrTJUN0MKWe
         0CSKtXEqGl6GRbaEwS4akZX+IPZssoyS8hnDRnKK+zkoubqRHCWdWvyb16s+77oKDJyB
         FtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741453734; x=1742058534;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4IcMf84uhZ1TJoFOuLgOfVe7+B4onn10+WD0mzIT9m4=;
        b=RzZf1RVpK3IUGpntmJL7I5NY/ov/3K+QjVe/GYWvkGAopE7+IPN4nodNP5xRo6/JNt
         CGwvZ8mnJGV/0ANrSi78tnUqq3rBknHzzILXzKZUqv2MLkLjfrMZC7CeoG+AO0zJejdz
         2XDqJYTfvytXhuXOznaMJR6XLOEY3hnUC5lpvF0WvJsUORDFvWz4KgfYisQ6h3RGcAP4
         jboFNn3LUrnuQAFXPaNs6Z2Yd+KQP70IgKwB7qfUss7kw0ZfNY/Dr/U3i6oMgU+Enod/
         ShTRkHjuwe5P9VscF+KCa8nrk2Oe7sYKWbQ1C4wBRZUPytaeVcBE+R8uZPZMqqj6KcxK
         OC6w==
X-Forwarded-Encrypted: i=1; AJvYcCUuQUWpx3GTfVp1YTaYgqX6XGwgQfarN4YVMA3azqLSBno/LZzFdB4WFrieItq9bIDP4Q32UzpDUbQ=@vger.kernel.org, AJvYcCVI5bp5UB+CivUqCYaKKvIEjVdUDfcdJzYwnc9uaNdmOLcp09rcP1h29md4ciCJ4hySycZa1SzfDGaxzWPcTZQI@vger.kernel.org, AJvYcCX9IXE+h+rT0ueZ1ghXNGRzwN5fWZSQBjyRVpTaayuKbkg2al0Kgk4mg+DRvEjx4ijhKqJOeKlI@vger.kernel.org, AJvYcCXjBMdWkxBMR/Hd8JCdwQaxvdSjitqH23OD0KbM0Zt6iFTXHD7khCWhHBQ3YC9o4fMwk9j8GlPY3fRIfj9Q@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6mIWEKy7BuQBd1rpViUwkjm32qBvfeCEoRtPO8q8vqF5VzmKq
	7yuXlnNcZz7x3t3sDRqZNq3pboJktkO9fs+Klm+nKw1+LmtF63w=
X-Gm-Gg: ASbGncvaxlvOBZtA4Sno2DFHt7rsBiGXpd4/6/GTuSlOA3Es6uMNIBsQa73NgUexMRe
	QUIihyfUrpp/Lwul/agvTeGZdrsngGkEuvUd3fTWFLXDEZDDBOfP3nlqQban9xmplB3LNAsSlrY
	6QaJ7h4shDMiX4EkFMj9FXif0Qx6HYZcIYe5dbYpQDPuoEsDMEqVTcutfcPDrJ2T1ZFnWjNsgHl
	bJemhruvf4SYrpGi7jP7lk6LbpxNB8puYdLkI9betjDKPlTJXyHn7Z3NZ17lVrk3ITbGvHs2lIh
	m+sq9wRmkgps8ufJ7X/7AR8Z4uObhp9v9Gp0h7yxYaDY
X-Google-Smtp-Source: AGHT+IFRZHlbgFDOueySaqdPee3EawbUTko5dKs36Wbsu+tzE6PWqif1pLkL8NZFxLhvNX2+zZW8Vw==
X-Received: by 2002:a17:902:f78d:b0:223:5ada:88ff with SMTP id d9443c01a7336-2242889d1c3mr140941825ad.24.1741453734162;
        Sat, 08 Mar 2025 09:08:54 -0800 (PST)
Received: from localhost ([2601:646:9e00:f56e:2844:3d8f:bf3e:12cc])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-22410a7fa3csm48879285ad.110.2025.03.08.09.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Mar 2025 09:08:53 -0800 (PST)
Date: Sat, 8 Mar 2025 09:08:52 -0800
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: Stanislav Fomichev <sdf@fomichev.me>, netdev@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	horms@kernel.org, corbet@lwn.net, andrew+netdev@lunn.ch,
	pablo@netfilter.org, kadlec@netfilter.org
Subject: Re: [PATCH net-next] net: revert to lockless TC_SETUP_BLOCK and
 TC_SETUP_FT
Message-ID: <Z8x5pI0suqOiZPId@mini-arch>
References: <20250308044726.1193222-1-sdf@fomichev.me>
 <CANn89iLV6mLh8mWhYket7gBWTX+3TcCrJDA4EU5YU4ebV2nPYw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89iLV6mLh8mWhYket7gBWTX+3TcCrJDA4EU5YU4ebV2nPYw@mail.gmail.com>

On 03/08, Eric Dumazet wrote:
> On Sat, Mar 8, 2025 at 5:47 AM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > There is a couple of places from which we can arrive to ndo_setup_tc
> > with TC_SETUP_BLOCK/TC_SETUP_FT:
> > - netlink
> > - netlink notifier
> > - netdev notifier
> >
> > Locking netdev too deep in this call chain seems to be problematic
> > (especially assuming some/all of the call_netdevice_notifiers
> > NETDEV_UNREGISTER) might soon be running with the instance lock).
> > Revert to lockless ndo_setup_tc for TC_SETUP_BLOCK/TC_SETUP_FT. NFT
> > framework already takes care of most of the locking. Document
> > the assumptions.
> >
> 
> 
> >
> > Fixes: c4f0f30b424e ("net: hold netdev instance lock during nft ndo_setup_tc")
> > Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
> 
> I think you forgot to mention syzbot.
> 
> Reported-by: syzbot+0afb4bcf91e5a1afdcad@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/netdev/67cb88d1.050a0220.d8275.022d.GAE@google.com/T/#u

Ah, yes, I was waiting for a repro, but should have attached the proper
tags, thanks!
