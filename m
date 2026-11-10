Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794273647;
	b=h9MY1EH/tDTJyJ3Vdl7dvNQ65zP7D2MPln73IhGRIfalOA4wEt69MGneNfOdY4yRoMJ8
	 yfmxcWgCDW0u2TXyXm89WR/MB7YmbIvj78+0eoTc87bYRjkWz081lRuaKalmrZ4b7VRcN
	 WW+gCGt27cm/lQKfSEJ4j9MAkWJhndJgeYGlRSZvH8dl1bSM4Oi234mvzYmiloVGV77c4
	 GdYZGeT0Q9903qB1GEcP3nCptgI40xnBXsKZaCJD/pzyqlt7d22x0nYGV2XLRwoo0+z48
	 8f/y/fQy9q/uLRBOdAiAMNc8BBLV7v0et2xXayzaW4Ueyt4IiHQ0RUrizT7rXTWrfqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794273647;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
	b=eiIQbOil8oonDg7zzUKvUM7UvVv//xyaXfc3BQW29eE6zRUKleXJbfwWmtDubblU+D90
	 4yoCzByoFzm41Ht77xPlx/bPMgjaWEKb56NSFC/6z2xPjsjLkW6FYUiCbOJr8V+RA7mn9
	 tG0tbWp8+j6onbq/Q5tay6aiK59BNlJvHEtzAu9uvEydwKgOflGCuw1EtINCDY0A4TJfT
	 +ngEqqsEdytURqoNFlEeVrdwbc/RMqD3AFdThGIG0xVEcnZMsJaofVB2Eq0nDml3VdZa3
	 Jc+GK/XNYZJGz3vAH0zI+cxg5+1izoTNE6j6tDTBaPsxXigRrzZyxj0GaxNa4bWPHkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=WcZYEEU4;
	arc=none smtp.remote-ip=209.85.218.54
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE04606A331
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:20:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EFE04606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=WcZYEEU4
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4cdc606b47so217192266b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2026 17:20:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794273645; x=1794878445; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=WcZYEEU4iAE0CrQQrlGTG3NXjWQK2iHWpKNkc8XblYnv5ARhqp8wtPN7mpurR9y8lK
         0bpCo0ugX/RcW4FpLiJwuKZNQP6fj2LU4jueN7/TbZJ1UONAIfOnwcU7EheUbt7jCjBS
         x4hWrpH74phWV/BXueHaYHSS2ArflePZIRhpY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794273645; x=1794878445;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=m2qXctBTC0OPADf0V2KkMb6r2GA0JgabIuFAMe6ERzQ=;
        b=bW+CYrhKOfF/QWLOHK75qFT9quRzMJG3VXOEDwduQxYboInVZZsPzdulI90hLiecqd
         lyyUusjgAw44DD+Cb7Ij574ydfvEP7vHRucdZ0FbLazOBZ4vsWFmnctdZIZE1v952Neb
         hu6lQLfcFW8Yycx0FCDTj9HP+/0Kl6G1t2VEWh2+HfG/cswBORuv31l1UisnTBv8VRPs
         9sR/Ls+p2QNM0YvHEMZ7AkiEoUED0LLByQauodflSz0Q/QVH0ElcMCazr6h3CuwbAAaO
         1eytvvqzR+yZhus9TbMwhgee9houP0+JThk6Jrx4W7M1YOXSrxGBDpQ6JUkjPcPziycp
         Brug==
X-Forwarded-Encrypted: i=1; AL+hErHpqQ+abV802YIYhWwYxV5sqBc/s1AOkKREj/aOHnMkkRsM1VOHLYtmEZXCEBQTAy08Q2VJxcR+wxQlLt3A4ug=@vger.kernel.org
X-Gm-Message-State: APuU4Z+aE4E1UeUTNEp2wR1iH8664NvqbZ1MeRGDvtIlY3+ZT9KGhHtr
	GnlvU1PsJL+gP2FVc+Tcd9AdVz97SgEYbwkhk1IdUczZ9NlXwv/d0X8o+G+z5OgzwBQfYC9L+ls
	f654C7Tdnig==
X-Gm-Gg: AYBFou3UOvgSmRxEe/bJcMSjkRataX85+rcDxUWbv56sPKgQ53xhDZwgMecsF4zuFwy
	Jz6o3ND5nCxqU2hPlogDai54sTJRyGyj1Yep5p8py6+tUWZMdMJv1XRJLxbboUsisPnx2iJeUmq
	GFtXHIT83dlaes9q2dj//hm+IkV7tHnaYbWoTQyI7M2QvvwxQtF/L+aJ9YKSdgb3dHcW/rAjt2y
	T1inmMfc5B4dvbUwaZ9Y/Bq/CqgHNoBRKd17XJSssqnsZxak3UuONbfOEGSH0Oa+p3as6CxKxwl
	I+RqoOWYKaO/e983wclWQIYSntPK71LGMgpqdVDWcTCloagcmL7KncMg9neS13pT98Nj9MtXxFr
	o5FEy8VFUOxNr2nOd6o/hWJath23MYxWGnN7UuEmqhGu1AAYtZxRn63aH1FJ8OYE+cwoi7YB9F/
	ocrgfyuhnVRLM+thdf3tsFjG0HHM3Dfb+XaJ2Xu+S3unrtf9pfHiQG4Bzf91F5EbRZazlJjOTBC
	Gly2dwR+S7tqG2VweHka7QNa9TTjSGH+SOMIGqW/mSkI6AMZoxnDZMkpZLZIBNTC240INqHmTpd
	gaEUD5wQh0GMTL2MjW9tp1nk2LGQUi2p7YqjDlLAgtjQHtTeJ+APWLdsxGj/7pxAyqfLzUuehYt
	+gg==
X-Received: by 2002:a17:907:8993:b0:c41:960c:8c62 with SMTP id a640c23a62f3a-c50496a41d2mr74930566b.30.1794273645295;
        Mon, 09 Nov 2026 17:20:45 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a64f888sm40776366b.66.2026.11.09.17.20.45
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 17:20:45 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4cdc606b47so217191566b.0
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Nov 2026 17:20:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGDyCjLf9JgjW2FmufrX01HhAvTImr4CZSaz/MjpX1R5ZMcyczWROHzIwl7MvF9TluxYmkhNpxQYyqmITRnR1s=@vger.kernel.org
X-Received: by 2002:a17:907:9451:b0:c41:1750:59a2 with SMTP id
 a640c23a62f3a-c50495dfbd5mr87253466b.12.1794273275844; Mon, 09 Nov 2026
 17:14:35 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
 <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
 <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin>
In-Reply-To: <20261109214558.0d9d5228@pumpkin>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Nov 2026 17:14:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
X-Gm-Features: AclHuK-x8jcOOQUqd2amGoGEAKER9jIFGaeL4LxxWAd0cGV7dz_RR64PtDogpPU
Message-ID: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: David Laight <david.laight.linux@gmail.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>, Christian Brauner <brauner@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
	Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 9 Nov 2026 at 13:46, David Laight <david.laight.linux@gmail.com> wrote:
>
> Just that the cast would have to be:
>         u8 *foo = (u8 *)bar;
> where 'bar' is 'char *', and I don't think you need a cast there when
> char is unsigned.

.. and just to clarify: 'char' is always unsigned in the kernel on all
architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
unsigned") back four years ago...

            Linus
