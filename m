Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.170
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872387;
	b=bfsq/x5zAQTNThzEsRiny45d2QlfLSA7xuh0cffeBBqKIrarPkaKvZwMpRJFaTD/DHNa
	 /and5tMITIYA3yZUtVAO3V2w87iXRdv2LKMDEtsdxQ5SzIXLXXCMDiP60a/twHFfzBl4U
	 8lQVh5scGaVFFHdk3yTAeTsGcwWCciTisurrr7IZs5/Lx93ussGI3rXqg79S5FFNhQF2V
	 1cTAsW9lBbLPDxEkYdxhLGwH1ep7yRq35dRsBUmx96vuEg4qTk1euY4vaIqNhP/5AEHak
	 qGMdyWs0wLqPh4dERrGsYtfnv/sv1JhrPx957A3yqP9sweebEb3BpQsEeotK+OJR0+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872387;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
	b=wT5av6JMGRIpXXC6yzYEEzQR/RFL384j9bWWIMHX9r0ZshxQTpQ+XAM03kuBTV/oyOTj
	 xd7x5PbPvvRc7pxnwGKX9fYYnRgK4Bfo26RXTehixxOz0ETV26i5PHpMmlWdfvg5LC01A
	 gw5D9aKE3WxypuJF3KlaF9jtXtrwveS8ilxtNf/wtZAdqn1BqraLtro5T2D2jV9FBLm7N
	 +dz/HDp6yRS/DkZxIIvUji8amSemV4WySeFJrg3L6FnJsdngCX9/51PQiUQrSI9LGpJtp
	 dzMuFb22vIXsrlDxzbyeT+sDEPNCexdgB1nJlYTT8HOC9IX6JiFuB6FE7yRwpIo3anQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.170
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86F60606D815
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 09:53:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86F60606D815
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-5365f9a04c5so23477531cf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 01:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872386; x=1794477186;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=SqrTjgENN7Dfs+HehxbKPgACeb32UvvfMAFijNHd6N4=;
        b=2AKwjwo/ad8FAxz6P+M+ipKbrNdJGZbvUhuYCtia8pM4Bgngv2tCq5Q4NHkTFsjrYZ
         QWoIiUFtIAFlMGPQ76BUuAnn4uyk2a/z1OsmmARt4TokoCR3l6AFVntlGQFPNDcdozWd
         uZ17dP+VMwyMUqc1+O1ZEOTw6eQZPvNjmAcBxB6osD9kMjHyR1nwrMSN18ba65JxtBYL
         k+Vsutem93ylTbFPYgU1UrYl+jlznXHXH5LzY33Hqt0yshcNxNPNqIBIlWscItp9+Td9
         5Deh6mSY9BE75TsPNspVuxTT0QSnjs1MRP2fiOU1GUZ3quPnbBdTsYiiHZJbPW2We1aq
         ZbGA==
X-Forwarded-Encrypted: i=1; AKwUvBwEiv9nQzVBRy9y/VEbqz9R85YKYhc3Hg948ySsxrCpbPHCDSDMnjZNRaetn/K1DSVos+N1UDgIOdDyebwm6yY=@vger.kernel.org
X-Gm-Message-State: APuU4Z9TIlNNLnBXngBhKoVqi9ZV3oQo04QaF8mlZSIykyLZ98KjxjfB
	PdAC4gJDpO6Fkx78VrKfdHzUT8fx5+9tZhyEfHJ8+tLE2OhP4Oqh76fVHxtqbGDqhG8=
X-Gm-Gg: AYBFou2ULFe3z3Fi2F5M4HSyoKb4RhFpqb+CHArKk1kmS5Ig1YGGlmbXKx7rAKaMZY9
	L0w7C7Mj3kj3wl7hOTiRPWQUUBEzWORa+7bNCeQ7C3/GIWAdX+aLnQEobHYjwY9wSYgjG6SetIz
	xl1Mp3F5D8GRhmAqgN41jX4pcoiEPiEWLccBlNao3KWzpAYfCit98wT9b8RulQW5pFGF67dJMjZ
	MVgJvLTlJdk7WCw36g3KnO/VKuq7iyR5KP65Vzvo876ox7jJagHUFPB/znEk0G0JmUeyAsQo73D
	ersQtuAkKRO0ye/bSaIXJuND6qAbWLoaTy3lsrUetApAmRv0gfxF9z6SCAZovSrNg1SesOfUhr+
	FY3xY4dsFT51aCFOCh1imd5+OQ9flcYa5dwjeaKtknX5eALVqXp6K0C6Gv0V25v29fSWo/xcgzQ
	MftXc5HkSr4UOtPA5wihCoQFBXDPBvG2U0WIFNlkErzpYvGyKGAIZT70nTeGPT5gDSN8IdQvlrH
	k7Vu2TFJyQNT9PRJaY2kf5kEQYzJ1CRuRISMHwYZmGXSoEyDPHqslqC3ExbqLIG1/R/v6SIJ5dZ
	2BBuY9NwmVJM8mVBL+E011oKerB7zdArR0p5szGWE+HxVDb24VsIKGMcvMXyR3hk9RDu2g==
X-Received: by 2002:a05:622a:2b08:b0:534:3634:6960 with SMTP id d75a77b69052e-542b704622amr300668501cf.43.1793872386415;
        Thu, 05 Nov 2026 01:53:06 -0800 (PST)
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com. [209.85.160.182])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b1086dc29sm48101141cf.10.2026.11.05.01.53.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 01:53:05 -0800 (PST)
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-53c4b82919fso21020901cf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 01:53:05 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwtGquZpw8gb8+H96Q4WC1cHFZn0a2A0Y8VYN1SZXRJCu4Soo/Y4TVKghr5xmV99QWSwwXMjw5VlfLWa7ByQGM=@vger.kernel.org
X-Received: by 2002:a05:6102:3ec5:b0:7cc:2bb7:131d with SMTP id
 ada2fe7eead31-7d072baa484mr7324212137.9.1793871885062; Thu, 05 Nov 2026
 01:44:45 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org> <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-10-021c84d852e0@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:44:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
X-Gm-Features: AclHuK9D-nB8icBns0zdoQH8fV1cfUPJ6LOey8o_VlUZpDIGqKC4cFf8-j5-HdE
Message-ID: <CAMuHMdUy1RYKG0g8OWss3AD-jyYx3DXL0K7ABYkFUdxTxZ9VdQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 10/51] zorro: size the proc files like what they serve
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
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
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 4 Nov 2026 at 20:18, Christian Brauner <brauner@kernel.org> wrote:
> The files under /proc/bus/zorro hand out a struct ConfigDev and seek
> within that, but their size says sizeof(struct zorro_dev). Say
> sizeof(struct ConfigDev).
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
