Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069812;
	b=x3twT+44UXQz8E8XjYN+0wrI3Ny5n6zp+jh1TA3xQQYehnd7BjttTF/Wxj8Czsm5QF7A
	 atJUyiJmekXLqpr3oFDSe1VmE8SuKH6AVUbBYrCOCXmUyEwrEkYbS51lZ+DxvkZloxETJ
	 1JLDKEsXHOrbWxJHScnvOuGClN5/VRmyKg6a0TJx+YU+TePzPUtHbU4kqtc7K0mdxpwc8
	 YBCJXsid6MCjgletWhDaDJ7/wylJeZXozMeDQSTEdsnDBRVp9G9DMoBUvcRFf6fX6AWEE
	 z9846rq7cYcV0BnaN4Ob4RvsZKsI/qqcqKFxJ4hUA8nMLLum2Pl+0iNGm5KNKxWV/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069812;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=vJlfnNqej/LkG6MaOOq3+jKdNMX9ZNsvcUBYJfUwMpw=;
	b=sWaSbncxlC6c+WpYba+TC8V9urE8nmVdfDEjVeavjbBBv0P5qquJxIhlNN48H6CYTgfH
	 dCAOW65HI7dziPfP3rnLWa8SVrdTdhzcrnlN3w6FODm72CO/78tLXouyNbyvsMI5j1/2g
	 T5MfdfUHkx4J9l2AO+3M3WvZ7oZRj0f14kRSUVSorHu3YCDDV3nMjgeo6rAujkR0jiO5p
	 xW8D8G5x5pg4VQR+DEKbQd/RNLHnfmf8p8zEeTHhY5AgbGa/MxCDWxSDNLayl/8U8vUsY
	 E8mRvBXMThVElxocwQiU32kihx7s5/9qJlulYcJgxOeWhSE0YQSBHjGYTROxF7WIrBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URn14ZUS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D00D606A32C;
	Sat,  7 Nov 2026 16:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=URn14ZUS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30391F008A1;
	Sat,  7 Nov 2026 16:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069812;
	bh=vJlfnNqej/LkG6MaOOq3+jKdNMX9ZNsvcUBYJfUwMpw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=URn14ZUSHujYsiOHTH1FknpWKhq2JGT/Wcg4NPoKfIXDBsGTX0hpoXCNaDFBdVr3Y
	 LrUXN/UylwfLTnxmPH2u0snZEEwhvHPpzVvw70oe/+iRCtt8VEEuDNIjAhc5Iv8E+U
	 iCyEm8dltFsbB/vgqDpFMQ4NbdhjbXWQPVqTvxXaLy4s7TA325vQOoMxR3m+Q78ObZ
	 5oSZVxqcZXokGSRT+GyvJ5Q8fg/SK/s07P4nFNd5oTjff4Df4j6yR+ezrNUDVYNKkB
	 YiE5Z4blZBKkQ0H22n8eMlwz2n5MpTB1eCEDffxGe0y5muae+Fm8reshujKqz2LI7N
	 62+aV9uxm+esg==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 0FF15F40066;
	Sat,  7 Nov 2026 11:43:31 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 07 Nov 2026 11:43:31 -0500
X-ME-Sender: <xms:MlXvaricqmdkz4nJjHy6_1-OcNbNjJfOfMZFsMkBLpVfN9O9SJfEeg>
    <xme:MlXvai3eoFGB8GwhLZn8J4WsYKH4hOu6G3Q7gr8e4fXnWqVmSvgTFa-GpgxyHkOEr
    L-OQp2xf0vhZpcrfwkQnMqf2SkcZAd4Ack8XK5PBI0cwmyR1HQ7Soue>
X-ME-Proxy-Cause: dmFkZTFLL677GNytOzk0A+kd9ul4MOhn1Bd8CLtUWXIpAgb7PtsQ0aq95lY8R0bYfU7Q0x
    n5d0WBpD9FT2nvfoJmzNAgZYYIh2v8uIBqD+3kym1iJwW3NcCGcPRmVKGoEq8HTsd/5dJU
    2J48TZn04h0Zva9Se+6i0Uayg+tLAEGtZ9JsZJreI+85t81p0qV4OmLXyYVoibKnHGAmU+
    V84Ank9lExn6nPEXZTe/ek0+CRfDCNpZnvqcUrPRgnLGP7j2ClEUeekRiCJrPe1AdpWK4n
    iQP0pojNqeWGt6mvrMDgor3WiGAUwUn/0Wc1GIBJUaZVbab5Ly5C4zud+ZZmCdcg78sylA
    MkAoK/Ct+9LkIkCQHTqEcC7AA8Dm+XyCBSNHm91TdHG2obtXEwkFkvprz41Oubks9Sfcuw
    r8ZFF7zKrowRVymCMTJ3nHI6+8Zo71jCVuXtvZZ6w9cN8PmSV3Vn1s7VPQ5TgGXqHVraqe
    u/ZoGJ6QHgPjV17gJtXdfiHt2sN7ZYj6x6HdPkZbk8RpmhwlywyFibfUo2gMexHcNVBZpG
    rhksTaN91XMy6HTgmkQAu6nrk3lfjM6xIWzBlVuMR4FN3s8+OGMqI6oxye/ZeVnCAvWV7c
    OcJYn3qIDB/bjeL3B7VhC0AAaQ19NVf7PtpGN7ZfAEzvhDoWuh++9ymg0Qkw
X-ME-Proxy: <xmx:M1XvanFoWE96jO_B3AbQEY3Fgm7Vdpeg3rVFs0aZ7ZzrVjTy-FVuDA>
    <xmx:M1XvasgOGD898cTU-y0NCKAJa0gzkkq4FlzZwNZENFphZjNvC_BaFw>
    <xmx:M1Xvaku9YBTnGUiBAN2j62vBcN4ju9zahN6VGS9E7w_Ad8r8DuHRTg>
    <xmx:M1XvavuA3oRcXqag5vxh76qUsy08UM9e3UUXDGjXTsGUK7xhzSvxDQ>
    <xmx:M1XvapGwUANTzGTOxc9uEv1YKFK55EtxiSqeAiq8o-ngr74jUF77oHfW>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id DFD31782738; Sat,  7 Nov 2026 11:43:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: AE4uiykVHNXw
Date: Sat, 07 Nov 2026 11:43:10 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <39d3364c-d4d1-4919-86c0-695f75946c95@app.fastmail.com>
In-Reply-To: <20261104-work-procfs-net-v2-7-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
 <20261104-work-procfs-net-v2-7-221e2437fed1@kernel.org>
Subject: Re: [PATCH RESEND v2 07/13] SUNRPC: let procfs copy in writes
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Nov 4, 2026, at 2:59 PM, Christian Brauner wrote:
> Implement ->proc_write_buf() for the procfs channel, flush and
> use-gss-proxy files so procfs copies in what is written before it pins
> the entry. The channel file parses the downcall from that copy and the
> flush files share the parsing with rpc_pipefs in do_write_flush(). The
> rpc_pipefs files keep copying in themselves.
>
> CACHE_DOWNCALL_MAX and CACHE_FLUSH_MAX name the limits both sides
> enforce, procfs through ->proc_write_size. The procfs files are removed
> when the network namespace goes away and that no longer waits for a
> writer that faults on its buffer.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
