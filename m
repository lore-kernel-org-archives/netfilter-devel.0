Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793642813;
	b=Kvu5G+/okJI8Zu9HPfCGvCa5BF7RZHPHkt0BIoCZzItMAtWPLscakGh3zs2puTXWLuYL
	 aFGEyg0ra/wmzM1/DMVnAADIaWHzndrUh/pIqux8cuPmxmeprVTyU2vzOSWjJP5EaPE7U
	 4+0Ig5LsS9BKYWWlGNdnIbzUqdPZzbXxkQppIeq+dlXH1KcvE7u7ZrFLOz5ikCcZCl486
	 Y+K142PUiSo2pzeHzVeu0iWxmEvSQjS4rs5hJJAP0BMAqeYgW/d7sJyKGy7XpSocVFW0x
	 Z5dv8KRESeEI1PiLYhrL2RvTjn/ofzvCQHuhiUSXzEGzaY07JAr5ar9VJ1Ofiw1dJPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793642813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
	b=cgkxDZcjivbGaVa6JU/V1hrPRt6kmYuPROLevX1InDeKnhHJBg3Qk+Fzk28er054CVLZ
	 pZcYU3j7VK0gGHMBIbv4Sh+uMBvUUjKiOdlsviQ3vS0xcEuQoWdO1mB9DYdCgMieXvIxh
	 hQLdwcnRpfxie1vHmP5x2Q9whTsei7nI/YE0om2MeulJ3HZXSYAkkVDDZIg0CbAe1zGcU
	 fHvh2ud8vMinX4CjHcIbK4x0s8lXNeZxcEW53UyUg3vaJCcpD5/zG3tp5qU0Qemc4oi9K
	 7AcPKrSx2glAcqtP8Q6RFfzuI4Fux16/IlB4NW0q2Y1iBgUKfmlpDCUqgOhPxkNgYCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=eYvbncox;
	arc=none smtp.remote-ip=209.85.208.173
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060CE606A32D
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2026 18:06:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 060CE606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=eYvbncox
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-3ab3b29a210so35857551fa.0
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Nov 2026 10:06:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793642811; x=1794247611; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=eYvbncoxnaqB8sYiuJpKROjr0b5aZ9o6aPSeFfsdD0CwHn9NTmeNmGV99niJInz1LM
         44n2a4yJWvQqW3sPY+14lE9jlUKv7b8BlIJvAxWFCPegB6lXk5b/ClIl32N8i/pqu+Dh
         ivpz3WP4mFObohHtKbV+CUqNdg8qxbfJjTj2U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793642811; x=1794247611;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/vXXDZI2TLqXD/tqTZGHj/cF0YcMq0fXP1TpWYkM2ME=;
        b=WsZ3Ww1AcHnGjFUCEyUnxC7DERuRiWQR9hMfw4gOIHjDLbEXVWsf5PoWGJVvaf2wnT
         UsdH+bZkt3obiehqR5V9OIrZP/MthZFB3PoNULZ8723Yt8130H42ssOAEi5YJStiUP+U
         0grni+kD9beWxx63AMXn1A0zJLlFae31cbuqdqCEeYAy2Pedz4e3mQ2az9tSTKL/wfLz
         9CCyt2Xny+DnDPKw59hwNWmLIwd9zVSIGA4h4nGaerIC4o4mr8nIwGWvEprrEnQcPzp0
         WIEJQjnNlFGtqHpBLGpYWC4sBY+dv4JIOCPMyJScquBNHWqw+c4Fmv4FdUpmnRfujgkQ
         432A==
X-Forwarded-Encrypted: i=1; AKwUvByJHlfNaVCLN42HhkrFtY+v2IgYkTycjySkPa+i01sRgyAlGy9kCVwM89DhdtD5LTz2/G1/psKaRitV+l+pKSI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/NtZvpTFELx7wiAnCsrD3rEz8Jy176iui6A5MZytJzrVzpctec
	s0qfNhgjJl3pU9UVnxvOmM7ON3iexEpgk6LaYEObHhv8gewdohGgQ4z7MvPVecDBeS4upZa4K0Q
	CbXQur22WTw==
X-Gm-Gg: AYBFou3Byke2r8+Dylk/ZcpB5/VBQGy9QWnuQ4+CnHVeHPqlXTEsSBmjcUC1zoPU1QG
	TGGMBKFdjmnImr+KJv7h0BFJ7uDMafTn99jh2jOdVeB0j56mZ9whjSiJPS/LScR34DY7tYmR/5N
	TBEyjiogEoARFa5asH1qIdWs2XFeTK9AKbFPs361f/Mmz0SRVszncMh1om3/81hibzzjuxNdkMT
	KioHSytDirMtbxkkWuoZzl9T1M6pY5u/Y0rWQ9lkVXAtbR9lGh5HypZA3SoKYsWq8Qj/HmZr9kr
	6xN+sQ0jjwHVdUvBF7HBKWbWnm50cqGChiaBtTQs9RCn0ktqYMXjDAffekso9u8r1DG298uDQTU
	IZi/I2gLU7sybJ1b3n4T5DMFNu/02khhdOhEnf8CNesBN3QQnejCe0k39jxQwbRlzfvuCGh8VhZ
	qZbKLDwp2/4kmsImcmh9w+OB8cmtVPiEMnAV1OrYZ55jllI+qP4uztyznGAyMizgcM9LlUiuDaH
	SQ+TEarJA+EXX6rLc/ySNxVyKhsGFmtbsTNtJqp/1E7TlWNOG3wfzWulCRAUVOZi3pSp2iYc6xY
	0+d/7d9NxNSJl0O4Rt96NPH8F1P47Wwm815tc6rAcG9mng5p3CBltwRXeDnoYfoVKN4cheFiJD7
	yixJAoRTb7JtOg9E1vxZhTuIJChI=
X-Received: by 2002:a2e:be86:0:b0:3ab:ac4c:186b with SMTP id 38308e7fff4ca-3acb7a65ea4mr22978181fa.9.1793642811174;
        Mon, 02 Nov 2026 10:06:51 -0800 (PST)
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com. [209.85.208.172])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3acd5c2eee8sm806791fa.15.2026.11.02.10.06.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 10:06:50 -0800 (PST)
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3ac65e845a8so38033921fa.1
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Nov 2026 10:06:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBybSY0KHxPBOf76sFo5q7peTfF73o04iKDk5wTiSE5xeVgWP/7lX8JHasm1CxhvjrdrCwZuIMnO+ebtrjNl3gw=@vger.kernel.org
X-Received: by 2002:a17:907:d94:b0:c2d:c80e:8366 with SMTP id
 a640c23a62f3a-c4ca7426f6emr874452266b.0.1793642348398; Mon, 02 Nov 2026
 09:59:08 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org> <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-1-59422ed3e465@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 2 Nov 2026 09:58:51 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
X-Gm-Features: AclHuK_qZTBVsLQIdymgRHScSFenC6XsGggUDmcuOugjrSTbuVkeASUmC_hYPZo
Message-ID: <CAHk-=wiSA7-mqmAjTQDaU7UjUyWt0TxYwXHafL8ZAPudy+B_uQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/38] PCI/proc: don't truncate the position of config
 space accesses
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Nov 2026 at 06:22, Christian Brauner <brauner@kernel.org> wrote:
>
> proc_bus_pci_write() truncates the file position to an int. A pwrite()
> at an offset like 0xfffff000 turns it negative [..]

I think this would actually be better with rw_verify_area() just
checking a per-file maxbytes.

We already have that logic for lseek and friends - using that fairly
hacky combination of s_maxbytes and !unsigned_offsets().

We should combine s_maxbytes and unsigned_offsets() at file open time
into f_maxbytes and check that not just at lseek but in
rw_verify_area.

And then things like proc_bus_pci could set it's size limit in one single place.

Hmm?

                   Linus
