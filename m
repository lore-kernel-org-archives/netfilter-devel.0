Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653929;
	b=1Tur4x8gm14mBksTJdDPtqGxhWWdwfEjGuRFK2p4sRJMB5G8N+w6Q++a1rJVhsLXUX3q
	 ZdR7Qq9AuLTU3iva+BqYKDj8TOg970oBCWf98iGmU7u7Fmiu6MBdDNxD5CwAUmqJOntfl
	 FjLlB3v3jC1DJ9ERA5losi1nFUOt6U0H8JehsZIgS+ydr6OEOf2ZWxIFa3HI8oTLu4w5s
	 Ltwy9xcj6tYzGUiVblROx2IVIY+z6mjXdA+23hemsxoD6zErF7E23fJiuTmBr2QUqlWSH
	 OIWA7JnVj9jRXAlXURsXS9bCzu+7ohtrTuu85L7XCAKTUy5brvts9v63CLZ/tj8NZQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653929;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=2GzKULsklpP+bGy2QkTiTCDYRGUHpWIftO7smBM1HBU=;
	b=fMLMF5AlyWnrK8BGKFxks+t+XoXsRMa32k+Sgwuyb0ZZEmls8mvFKUgNzeLDVwHjv1gs
	 w3qHOPPlvxDyrTPIJUP3gZrYeWRityGKIFPUU+w6+tJcS4/UlEAccZzLFd4ABJa+p+Gb/
	 qTKHVba30Em0YlSbKIQ38TpBAi1war9jeWuziYUXVfznTpQyKvZCuIAYZYMNxsk7ir6ul
	 hQENEOTj3W0uZKCAWGNOqkfuhuOunJevAk9NzASdqAI4LE7InepVA+imsA1Uy61x+pFU2
	 lXEmGdKpozce//9VeVuPJXwvBcnZxYocA0vSXCLqvL21uAIL6GfQYegN8HM3H5C8Nfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eOrrqnCu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30B9606A33E;
	Mon,  2 Nov 2026 21:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eOrrqnCu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59EC01F00A17;
	Mon,  2 Nov 2026 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653928;
	bh=2GzKULsklpP+bGy2QkTiTCDYRGUHpWIftO7smBM1HBU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=eOrrqnCuBcAP2fV3PXFfcEJwMkbwRAGIHp6KCaFjIuyf+sB1JHZdbkgspwPLwt79I
	 FXcIAf/upp/+9o6XUcQaMC14vFQxQ6eh9W8VfoZZc26/0Zh5MuJ/0TM2e0uyfW4hkA
	 QLktWfGN7zznzKizwQD5uy/9yLbgnxyAE6t6ani+AKBcNVKVkHnsQ8helsDtzQiS2E
	 q9cRneHEfj+nRxs45bkIcWQv0qDhG90LIAcSe+kfsWxW/AaFZXLwNirUt+0C02LAuE
	 8jLD12JMKQWRs2u9qRZKZEaqw2EosZDvi25EsVp4XP0qG99VY/JBpz34fze06k2ZE0
	 1KTIeVp5fXdhw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id B11A3F40069;
	Mon,  2 Nov 2026 16:12:07 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:12:07 -0500
X-ME-Sender: <xms:p_zoapr17E29H-fSQ5ao5UDU9J0d0UN9LslRMK2Yot_NizRnTFEkEA>
    <xme:p_zoamfCE-S7Hs-CSPipIUil3YlwaRZKX7BUg-QHg-cJzQuryMUebhuHqcqrGO2My
    Eg5TEG_P8cg0UC6V-oxZTejOTfI-6-kMXMS5aIVpyy5EBl8NJuOZyQb>
X-ME-Proxy-Cause: dmFkZTFs/jmIsOXvjcGBiso32MoDaWgH4iC1UWSX3VoieAjEEqJt3ar33qqWLUiTvp3z55
    l/lffrpMfJBR21ZDDnKKQZot/S8Ds6UkbBkCGKTei2C0Ja+WhBu0PN0mWrm3sqzz3Jp7lV
    Jv1K6RPYXiNNlXqdrUFYO5e1msLfI8VSiWnLSS5klgvyo4xAyWRfwC6+MNLjKoERshPwGl
    Qc55QBtPREQD5fwDYU/ZSFmh2IMYgdQc04iMI0NC2Rh46JSdNO4k9fa1UzFany6ha7zsP4
    nGREtdukYBrm2r+m/tLuFErrU7i5fnQayX1JE0vmCRKjtAvTf/+g9c8agVHFyS1mBe4TlY
    tzy1MGmScGSpYH5gbw4YWcUaDYKm/1Gworbe2oPf8WO8Pq2PukV5cF7Hrz1T4e20ZOAfMJ
    pOtihf6v5J+OVQqXgMGVRx2ye3u0et5TR7tXNZ39eEYU7573MDGaYM5uL/zjFleuwDIH4I
    piYQUR1gbQveGw7lAmFaS/Opm+cjvdT3L+x2vvPYhPiVWOcMem7oCVHkFnTCXUIAuASgYK
    Fq1XUHcc2jX+OfUipIn3mT/pvOZ8Aiae+YApdQYl+NDbpGF9WnByqKq1WypdSeLOuEPoUu
    VP3DHK4bRsNLQUxd4rdJHA9eIoADoM7h61QX7G4aJQstpPOvBTdSCQApZMyQ
X-ME-Proxy: <xmx:p_zoanP_XSANPspRyS5Nz4OzOu6eC3yx5rafDiBnjc7_rqVeZTRC_Q>
    <xmx:p_zoaqIm_TXr8TwllRIqoluxHyfJ-0Is5L2yC8VX1VAfDyKD0QbqKQ>
    <xmx:p_zoah3BURDlw14O83vBX1r6sL6aVVfVLuMLRtQP-g06NREm6axXHg>
    <xmx:p_zoamXNg_Xnc-8U4wmQ2zDJVgwStaTO4e5-GuWgSZ65ja4A9Fg2tA>
    <xmx:p_zoarN1EdqzZ9C014dxq8AiKhbVC7SUS8_O_gy6LABwbK1OuH9Qn0Vl>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 96E7B78273E; Mon,  2 Nov 2026 16:12:07 -0500 (EST)
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
X-ThreadId: A5s7LfNSi9ds
Date: Mon, 02 Nov 2026 16:11:47 -0500
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
Message-Id: <7a864852-252c-4a62-b4f7-33072e33b7dc@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-net-v1-9-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
 <20261102-work-procfs-net-v1-9-982104a4f592@kernel.org>
Subject: Re: [PATCH RFC 09/11] SUNRPC: drop the ioctl of the procfs channel files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> do_vfs_ioctl() answers FIONREAD for regular files with i_size - f_pos
> before it gets to the file's ->unlocked_ioctl(). The channel files are
> regular files, so cache_ioctl_procfs() has never seen FIONREAD and only
> ever failed other commands with -EINVAL. Drop it. Other commands fail
> with -ENOTTY now.
>
> The rpc_pipefs channel files are regular files as well.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
