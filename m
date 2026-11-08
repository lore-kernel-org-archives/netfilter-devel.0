Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794164398;
	b=TnShMQIPhOGzus3wmXw3tbvdo8NiteqJfeHoN6oiQ/RazAGSC5q0y8TnF14UpbMMfZ0C
	 ucTgpqyMIZkeWO3D0xZnK4Jr1xhu/wFfeK+diqQWhnbOC6skJqsNi+TDivlB6Sm+R8hF5
	 U55LZdWrvk5aEpsY4lXtrXN9Mfa1QheM54t1h/rX+6uxlorKn+Yp3r0VD+AtWw0MHEIuN
	 ERwsX/utQ5X4BUg3unXemS0kfmZvJS4zoaTzbGxeqeHHr1mL5ZMHlOZ68zU3KVcIRXXZB
	 a1OdjFwFaWeDJg3U01yWbB7h/dOh2NhUj2awNy9xeo4KbmqL/6xNDtxr+b9JpRwJXPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794164398;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
	b=W7ETP1tvfH9DhfZwmtE3gUop5VMmF4OjgDxvdAt1qnlbPr7cAKTc2cwT3qb8ih0xPGeQ
	 xJ8jKjqESX+v8Mbd16r3+Q+Nm3MsNU1atbf42NaXOuJbpwiE4RXwRhe9W6XY698xs5N25
	 x55emSL/Lnw6BqvVkY17SWmnum+k5M5Dr+qph+1D2KuqHQsBG/+16KXLKkDUu1wJ+Io0Q
	 DPEmeoFc8Y3TUyKK3M7I8movxD0XcY/7Swy0VSFrmZ6VHQJ2yJj9vehy7dsf6SK/EawBu
	 JPRSNLJ+Q7LmwkPjRPwJmzZzRzUxDyuHnku+gdjACxfN14d4l7tXvNB4zkGAhvHn5aA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E8C606A326
	for <netfilter-devel@vger.kernel.org>; Sun,  8 Nov 2026 18:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32E8C606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XrEUEgHU
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a59100fa83so1416345e9.0
        for <netfilter-devel@vger.kernel.org>; Sun, 08 Nov 2026 10:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794164397; x=1794769197; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=XrEUEgHUwv+lt2Z0T4RzlOQuYT1yMbnY/MJrtF5HY2pc8m0ujKE+1IGJbqc3A1SsPJ
         Pz+po0Wh7ECcrOl1hyNdZBme+OsO/r11IeCA1lW9KMbstFhlOkC0Hm7Ef+TTavGsfrDk
         7T2AE8nlcorDhYFpLo0KTCt4xOv09AacMRilfH2h4PS2mZ0iBReAF8XAcgtI3iT+qlRY
         EJQPYUIUlDRCCjadf1+24R8V0flZyhCZpLCroCVsidoQ510350k4POOaAcSXgGRrBTWF
         rbpUnz5O6K0TOR8uz/zwLHiObwDAqnCJFWP0+ssCNYCBYnXJwQ2yMfUqdKkv6ro/lp/q
         XMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794164397; x=1794769197;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JLhUwzup1lwefYy8NOOFjthYnrByVfTsqIe79kkV+Lk=;
        b=0/s4c4p33A3xAKUcCQHXGHDmwkO/M4OHu7KW24vACmDxOP1/oGiWAbDbP7Ve6Gwuaj
         UtIXagets56jhuH2YusQKCY1aZBJikg8vIDDHikGjvp4cNYCckj1ctF04JMPFB19xJx8
         7SSl53eqNnBwpC0zeAI6yxIeLIPue0burn0lmBTmv2m80J460uaDHwEHPQApj/pm0HAj
         +7xygrk2B+W9Z43mlmGu8qPitKOtSH4W7nbVLjqMWpsk8IdCxBxOOmh2eJoOncHivjtO
         9K4vBC0gYOwPx9KleFsbzN54gQwTq19LbhT7FiAwcu2aPQUcMas0+1Af2c/LnlsBnC+I
         KSRw==
X-Forwarded-Encrypted: i=1; AL+hErF0krYdhg2Lenj4mA1Kop+PCpJy5FTnJedF37VAoMe7sWb1fVKPXOxBmiyT1kgUTHf7IzAoFqYMuVFIRnoUotE=@vger.kernel.org
X-Gm-Message-State: APuU4Z/dY6v7yUGk3GbQifYwSDCqW28juYy0D4cArubYDH7yskRzfvxP
	MYFzILMeULXM9ryl26CdZjDB9rWGoUpygpmzyr05xYIFcbrEwZgFvqJX
X-Gm-Gg: AYBFou0pIoqgyxHfuilW+T7Idl4ueMLpLAe3ajh6hYjWEek1sMG9HW/zcF7FUv2p1BJ
	sMVE8PbZoWbEe4z9uCxVvHtNF+i1yVDhKU8/epy5qduHCQaqP6XR1wT+uyBOyJWIndDwPIC4Za7
	yTXNy4Gl+SYfSh4NdqXwnHmEIiKbdCcV66/L2pXckkhovkMnzfmJrFMB0Yj6bWczaSgOPuAklTt
	Aac/iPBBy1e/uF27FtYPwU2a0dLv605hVEdlwNLfHT59cq6QcEDn0rsKHFKOz7h7JsRF5VUsVm7
	rlFKtI+JzZBH3fqSxhRjSeGfFVM0ZOppwKeylax9qqr9xApet/4EsSfT4QNTLuia+3s00ASFpZT
	wkUtJUWWvVEdt6i6YEhcfrAMJnNNl3uXD9/IvpZCkDEz3bVJS7QsIUqOBgZgirmMcR3Mpn8GaAv
	S8RRJNcQvYEPKfciOmRLgLhw6kVs8v2XGfk8slGTtWqEvzviG6S9e4bYpRli37Hsxv7UzDteWd7
	2JOx1b5OBMeXXjd7Z2A/+DMXWgiq+y06tKKh02HdNhm1ipG9gqXsbrGlwaFvEErYC3ZuiFLob/7
	FL7mStRRdwi8qQ5Sb9MHEUE98hmnyuuOhyCtHutdwbsS/d5BLVP/8Xsor1ZGJGLA
X-Received: by 2002:a05:600c:468f:b0:4a1:7e77:c382 with SMTP id 5b1f17b1804b1-4b960d9b170mr35982125e9.5.1794164396406;
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7efb1f3acsm185228445e9.14.2026.11.08.10.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 10:59:56 -0800 (PST)
Date: Sun, 8 Nov 2026 18:59:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik
 <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, Jeff Layton
 <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet
 <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Al Viro
 <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph
 Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados
 <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara
 <jack@suse.cz>, Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, linux-um@lists.infradead.org,
 linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 netdev@vger.kernel.org, ntfs3@lists.linux.dev,
 platform-driver-x86@vger.kernel.org, coreteam@netfilter.org,
 kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-mm@kvack.org, linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, Chuck Lever
 <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
Message-ID: <20261108185953.28054fb3@pumpkin>
In-Reply-To: <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
	<CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
	<20261107-akteur-gemieden-eckdaten-21304d085e35@brauner>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 7 Nov 2026 10:48:35 +0100
Christian Brauner <brauner@kernel.org> wrote:

> > While at it, I think it would be good to use this conversion as an
> > opportunity to replace "char *" by "void *", which will probably let
> > you drop several casts from users.  
> 
> So I tried that too. The thing is it drops exactly one u8 * cast in
> ntfs3's label write. 

Since char is now unsigned that one isn't even needed...

David
