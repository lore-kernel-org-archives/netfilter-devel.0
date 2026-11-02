Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654100;
	b=YdDcqFflM9NIABkuoH+Pvgct8zS3880+bpMC2rFBljVwxNi3kAyVpRUxEHr+tZs5aHxj
	 UUvFxn944G5b5JRW0xxYE2BE/4YSHaFYX3L9uf9toC3OVhWenGPPgjWx1Jm1aAZRZXEh1
	 j9RIt0CO7GJBTwt7QSezDeojrp2qNLnGdYdVB4wxSj/+wv1wXVFKK1dR6K0NKY9lrLo3o
	 Ms/ySaKKf+qdkxw5Z8g867QydLi6gfJ4nnrHr8gDmrGZVVJxZsjHWVmUwiTXKRZ5CiwMk
	 mtABUI+lboh+23MhSkLCS1ZYDA77g9kuxzAfTJtnsCoHZ6I1Zjow1TRDDfKzq+ibGgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654100;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=IboT5prE1F2zgLUjN3M8JJkwTsSKYt9w9Q1ZY5Lm5jE=;
	b=Mq3av9ZMpZhHWbaTAhKLopZbzAOpdIH702iUAVXjDrq/sUy8ynMB3BUo/m0G3/nMcnBq
	 wVIvGNDTt4JshXVRTDJbptgpQQ1dSGUV77FFx0VotAuTP0CPdlc/Y85EkmAq9WPzVHESq
	 EjRot1uJwv79Ty7Gv8HTk4+77O0HJHWrANgVukbv4D7jjxt6HL5OR5cRqyf8r40pbmcRk
	 2PxhZa5UBvj6iXdvXLlG3LGcKTzHqE7K++1bbJ4TsA3P88So/2g1xPFtVhGju4ZVKjtBZ
	 qc2QP7beKPMEkEgYXGQn4dmd5G4bNjWJDkxmNYHu3L7fWSmc6CFIg67qnszOQIgj5pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQQS2O2A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD58606A324;
	Mon,  2 Nov 2026 21:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iQQS2O2A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53B91F00A16;
	Mon,  2 Nov 2026 21:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654100;
	bh=IboT5prE1F2zgLUjN3M8JJkwTsSKYt9w9Q1ZY5Lm5jE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=iQQS2O2AfQi+b0NdK1c/IizthlwDmBEQCWvAB+m+GRkBQynljQMNycIudYc/9h+f7
	 Vawkm19O3oDCTmBHyvNQu/VA+okB5t8Z9fKADvjwmVYg9kIDcYS0RGx7iOgEusCIt0
	 sSUI2zMCBo8GTTgwELt8DWSNAXGAXBVX+K5v7+akC4NonZ2T53NHL1PfwdD1coLE4T
	 UgMKhDsPZNnCe/lwhxhJk5/Y/IQS2vyCvDzuusO+IC/e8MHzZliwnwssfEHb72ld6S
	 NYbu/taiK9urXN1VFBXtl6MzT92tBVkBKu03gGwf0I/CNsbIMUlES7wZk9EI6GVBLy
	 iYqmaA0XMCbyQ==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2F76AF40069;
	Mon,  2 Nov 2026 16:14:59 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:14:59 -0500
X-ME-Sender: <xms:U_3oaryk6_helL1M_uAN7EO4qMybANaa-srCik-GRitZbuqFboBqdg>
    <xme:U_3oauHfNHMR6hcCtpSbJvTRN_ZuN_nAzlCwpnkYqtzxS-rn0UxdTBvWBMWNMs9r7
    a-ZlXU6FghOrVMCcUPo-AaD5xEXA36oq8MikTMcJ0_wa_b-qCwAZ-us>
X-ME-Proxy-Cause: dmFkZTEUxvGtMocayGr7B4fSypLorEWulbSGFmyciE99PbNHadsfRj8oJMbJRxHXYsxQIt
    HJax8p9oKuSMV2y6UVPmS/4j7HUd5rjIX/3bSv+WxKky+Oywmc7N971sq4gj98vooi1loy
    1VA4HgeZfWDiXpb5kDKi7xQxXbyPK2MGwwLJpyE0xfXqkY7E8sGtcHcNk/wnkUWUjPmE52
    1fC16geqAcoXm2lfB137c203Fk7N7eknF2FospDFhgMfqTlBG0mACNYr8lQadBYMcFzIwS
    xdMqzJiY0yP6EWwdn+kTLuDIPyAnmsfc+Fkh0eyedsvXxZE99U6Un8Iqi+BS1rjMOYe8Fz
    cQe0JnCi0QRuT4GlGVKOTxdQDJQGBLvWqhAt3O8bWkvcJjRQxhfL/VM8iaZvcS9vZVKk51
    cvtcJa3aRzY9vaAN5UU1Ibv0Pajekkt1DB7g/9fGfI4l4GDXk/sjiDzMLuqExXW9bP0HpI
    dlkRN4hQD6iF1Dpni2XhBAYy5+SXfWyXnYl1AI+JsbefeEaEHWJH579nLVVLQ2RUreV63D
    i6ZwKTpLmExi/BxP76BApUlOAt1OWFEGi7PV30tQX9eGSmgvI8ft665RqCVrvfcBIoxi92
    zFQPxo3hKtBKIYJAkTnATb8+t0TRoTHXfm/yYurKbQprEJCDPAhlI7Iqqfbg
X-ME-Proxy: <xmx:U_3oarVQi5FE9RSxGSgbagw8vTijh5nt6FAc-00jRvkpLed5l5vdag>
    <xmx:U_3oarwLIkKyHoZ6LAwzX3ZogBYMe6ySqBqbRllxe8MLJ4ae98X1cg>
    <xmx:U_3oai-p1CErC1ApULRKgQLiL3sE4oRNFtrS1t981SDT9sMZWzyrdA>
    <xmx:U_3oag_JWJPF20j5AMkb3zRn4u2LwnHCyu-zTglkeuv_nnvMExEErg>
    <xmx:U_3oahVZk9Q3hibEcmT34YwGgluelPXvf0zWIimHFfvX5LF4LQPF-Sg6>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 181AE78273B; Mon,  2 Nov 2026 16:14:59 -0500 (EST)
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
X-ThreadId: AlKaHQIBeldV
Date: Mon, 02 Nov 2026 16:14:38 -0500
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
Message-Id: <961e7e3d-2117-48ee-8a7e-a7a851ec8ef8@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-6-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-6-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 06/27] nfsd: let procfs own the seq_file of
 /proc/fs/nfs/exports
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Declare the seq_operations and let procfs open and free the seq_file.
> ->proc_open() and ->proc_release() only set up ->private and take and
> drop the reference to the network namespace now. Reading the file then
> no longer holds up its removal.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
