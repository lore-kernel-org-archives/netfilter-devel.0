Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793872883;
	b=rXOhVkBcocHcXtFf20giUJJJzhbKiqd+JkttkucdjoHnu89E80lIQGb62XoB655m6Syg
	 RafgvbhZAzVYwcxZgEnQLwxaJcITJhsVUlKJ2iq44urtyZ2Fz5YwRQ+y80zcVrIOJkNXI
	 8laxP3lSLK+f/IvddAyasab8PhsQfv5FOcZ1R03XfRpBVAQIbbe6JPRVx7/sq6LIXT5aT
	 YAO5z6w5550gQtzstm+eZd9b/ZFk80/Yy1gIXqwfUIWDQIAiS/4okjaZNTpzdnPMLFKAc
	 +6KrZhbtLDv+Wcg42a2C1f6EYVSyfbslLhm+stitwTuC8Of2KHFsGK2lp+Nb3RL8rpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793872883;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
	b=YN4iTA0nrablfbc7cSd9pD5C06hjJDBTXYjBsf3IbZENcKRnOekp+quVQYngeKFVuGv7
	 YJqWlc4U7cGpJVgY3G7YSR7TwI25taBBR7ItHVi4Rk3xrmfUWJS3UoXbU/1M29SdPyZry
	 OmvoPUPstEVCKDQffRhjnLlr9hcaGFd8eezM33csaT/9a4zzsJV1TcPg7ABN0ei5Tp14i
	 Il0Y6ErYxSCvcYB81BkmYVFTO2z2YHavI1X4HZgDBkI2wX+WGqr0Wr6JOJ0DoXMEsJN5p
	 CygLnETPsNM4EfO7tVnLDzbWBoi3JrvO9ASMktsRCgcjQ0fe7bO3C8fmaGYyniiqYHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B49C606A31B
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 10:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B49C606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-93f3c8958d5so188201785a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 02:01:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793872882; x=1794477682;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+1lmuZTLENNkpqKh8T8PUriZ63OKZ7RGcjsYNzzAGM=;
        b=wcFsDq1YLckx4+PKBalblfo2jZPLMhm0+hL6JV4E1Hd0spmKdWZUTAxt2+eWS/aVWB
         zOSqIPAxcpwKphAaDwj66U3DevYAJz/Td5ZlsoNcuTs68iOCauQIaSSmad8eEvRf9ca2
         mIlaVnNJys34uO6ITYymbfvZQqcC47gbr9DV9umCHp+5mOnnf1EDNUkFpQe9ip7h3YT4
         tynRcF/Vp2cuW7P+bBOt95UIH9+9Qtie43WEcL42Mrh3E96be3XbYeCpH9smcDGhqf+C
         XZu1rQaByzmZb91adP4KaWtvXDT5ojkHyDFipqRAAUv334qATURASNRoBFvoyPoi+DsT
         KzyA==
X-Forwarded-Encrypted: i=1; AKwUvBz3axoZPKOhLQ1sGNup7L7u/bltrxQfvDCLRfdMmhuA6lNCVdMglBiDDTLDXSKZC6Zsm5DX/WOVhg+zDSAxtW0=@vger.kernel.org
X-Gm-Message-State: APuU4Z9dONlQghDBwe3r9QZVXNVmE8DOkuVlC2hcetsAw9JHJEcYLqCE
	tfodotO/2I2UUyVSQ16Q3qaR1tY9zCafiBRMk0UqXEbs2s6d9VJ8cDIyRUu4ONNtX9M=
X-Gm-Gg: AYBFou2hnHCFR9875Bol94X5ikPiL4+4NGS4+8hgcJIa/7vLMxqQiAfEVVYvCqjuE2E
	qsaIAEAjk5dF+YpWaqubRcuvlBth6RL0XLM5/qgblFw0u0yBkapkLLwW3MwZB/puIw3dfbwqzoz
	Alqf8ahWpL9jLVDf63/6N0DvPgjIUOqgGpnTZTQ6wckWwwKTcngMys5/oEHQAgJKVPX9WOUeQcp
	PREaZE7ZiN36q1UqsllR8DFJjHnd78x29htwJMOPYYAhjnTx1JUp64twb7yP3GOGK9xkRxllQbS
	z/WyqI65dC1HUWemUlFgft4gBqNzfaevmfHz+goBceWc/9RBCc/LTCb2VdmmH3PvMMoxQeNNyj1
	FM7WwxwBhrQQUvIs3ZhW+nMUdIfRDYdQt2HErcA0nscRwKZRTzIuNsWC7QgiNgROfjyNpaU9Yiv
	Gj6GgLJIuCM8tybseKArpK2rFDA+LTE0qUwkl/lfW4zvm0g84eYz0HfUxqmlZWnJkkme1Mlil0Y
	KMVFcRYkM3I2xPGji1ztBqS3HAsWG4oaFotZbaYBMSrBcEriracd/3nY+atI0ji+nBcmzvbR6t4
	5xy4bBksK4l0c63rZXm+599lbm8TDGHj4IMNBceAP5qKyxXLKt9UVJtCyJvGzfBUgA==
X-Received: by 2002:a05:620a:29d4:b0:93e:f931:a886 with SMTP id af79cd13be357-944216efcafmr3059628285a.57.1793872881947;
        Thu, 05 Nov 2026 02:01:21 -0800 (PST)
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com. [209.85.219.47])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-945d4844be4sm427135085a.29.2026.11.05.02.01.21
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:01:21 -0800 (PST)
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91c79a9a739so23689036d6.1
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 02:01:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxdhA/v2B1v3ptZpriTHanTaA5Lq/Zl+hhfArKm4VLtIU3rxVElJHZTIIU/4O1gDIm3K1vEBtyaFl7zYI9neHk=@vger.kernel.org
X-Received: by 2002:a05:6102:6449:b0:7cb:bc5e:7dad with SMTP id
 ada2fe7eead31-7d072baa450mr7614890137.10.1793872492413; Thu, 05 Nov 2026
 01:54:52 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-arch-v2-0-2aeb952c9597@kernel.org> <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
In-Reply-To: <20261104-work-procfs-arch-v2-4-2aeb952c9597@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 10:54:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
X-Gm-Features: AclHuK_RsrcE7hVRjmpZezBV5tMd490Mza2XAQiqUTgUNqAiHAzRP5z7NIbtMh8
Message-ID: <CAMuHMdUNBs_NyhFpXonirMXkYptUWsAizMvVpGHUDLzto1LGJg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 04/23] m68k/bootinfo: let procfs copy out reads
 of /proc/bootinfo
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

On Wed, 4 Nov 2026 at 20:36, Christian Brauner <brauner@kernel.org> wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
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
