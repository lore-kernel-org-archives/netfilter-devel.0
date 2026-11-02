Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793654075;
	b=ajswLzp0TuPsqsyvYEobMXhtp2ypa4FGSUkai1Z7DfS9hA+gnmt2ji6kkA+9vJjCZyUq
	 cTNANt/eVHR3EJPDGI8PMC2Xhzo1p8EmfqEq9TF9hE9hxEhLb2k2Mb5gBVPEpDEFcPPwE
	 CzypcX8hg05aqV1wrFp+6VKjHUM5N1Oh5M/8e6qft7W4MKHbEqJ+W4zZY7GAWQI6VgDKb
	 6ZsSEIplgKhfLjK7ZwDnSppUeynTppycKZ6YmOifluowFNU/B5suBc68L1vttr+2/dO+a
	 xG9bZ4Yq+8dsPkN2Z53LJ2/HKrMexSU1MqvrQdM9jh17OVpoDx7oHsSj2UV4lHjmpSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793654075;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=e/MGsEabL/7GG396Jx8SjaCfwMIwyJ2tMCUpq+3DLDI=;
	b=MHt66ezkF7Qg096ziyV1nd6F3t8gH8F0d144ZE0tTVTbaME3LdMndg93345cp2vbC9wS
	 QodQOJrTUssvHyOIyUZZacRNst5krR2NiXhlYdNUNfTJn4tq7YxtSNG6dkja1pFiYpkRh
	 NhUXfJ0G+Sk5euu/NUxLEMiGpo3kh/7pZiuvoUkmHuRreVyD9/LbplBgY1UF6dAHVlj8R
	 WYdu6sBAvHfkkZRDIyDuwCAdr9xCyd592Z7N2X5mkIzTUy7qtRyxpyUpk3/m802taoaY5
	 uMNPii5Bwg7Y62sPqzke+kdvwoNrJMWE9IVJ0gC1DutmvW6Ab67mlh3xOzVvZSiwRFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2OLFE46;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFA9606A331;
	Mon,  2 Nov 2026 21:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2OLFE46
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90471F00A1C;
	Mon,  2 Nov 2026 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793654075;
	bh=e/MGsEabL/7GG396Jx8SjaCfwMIwyJ2tMCUpq+3DLDI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=e2OLFE46TWKu5xklyz12ylfAApWKZbuHBOHbJd4znhtERP8z6pMgTnOEkR0yCqqrf
	 X0ZpIxeRlmWvAmyQE1zfgNegRkiz/UubbxC458xD4vJxAxkhweyZ+HBxeRFiQik0hK
	 +wEkAFlMdFp9HsCjiJFPZbKeeOwmN0SnZ5aHmLjB22Z3BdJ0oGBndBu3mtUx6S5oE/
	 tIdpACOgd6ZR4AXos/A2m04KYmJFV8XvlO+eyAdHJnBloO1fr3KqE20ddvUwAJAsQ0
	 ou2kTaLAFJf8XG/NKph8fFPzcavx2664UTYz2c3HH020DXXlEBK2jAFQFfsL593flq
	 hlsd3atef5CFA==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 12677F40069;
	Mon,  2 Nov 2026 16:14:34 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:14:34 -0500
X-ME-Sender: <xms:Ov3oatx4XcrDcK_vmDNKUCGOavYT1LKxhIpojJf2P2Cvti01GTtbfQ>
    <xme:Ov3oaoHxwDJF6MjBmxsppoUiZylhMQ10eGDz1RABE7aVbjnEa63xVO7nz63nha15z
    IFmNAlHDZPeVnBWow26I3ECBzd4JqPV9I674q5rAsO5NhmkKAClbYMm>
X-ME-Proxy-Cause: dmFkZTFw1OZPMSm8/KZ0gOkMh3tXzNybElfga3Yedts4zrqN/q+3jVoiqIwWz9Mh8WvIjX
    lcVivMeD/F6O5pr3qc9Ut8TytUvhcAUxc6H0Nyx+rHh2ZHcqVgHwwhnTmQP+rsxVj6XMMt
    e3E6bpZbcUveR0pMgcfBMTszgDiBNGWdc/uldJLMukjcNUouR3GqlPUzYMuJHBKFlFujxr
    /eeIxlrxc9ZQqYRx0bYbpk0xrN+NlRnDIl/SHfyWyCFEmsgByLzKD3kMgXvr6DDsqDwTJI
    zf/RnyA/WXlZlkIBg8Lqd11sPI5ICvzJyZGmNDvcUcrG7X9o+Ooiy1nQ0ZKlO4IMc+R8Ch
    BHfW+9aKWN0Ns+YdmMhOE6c+Upbz09Og6iBtBZIvLvP32I1XbnQfPehjIYjFobJrcFiJYR
    IzQQvbDmds9BKbdCsdWgW9zsuytqArJG8nF5c/iZOfUepYnlDnPQ6lm4ycS0nBTgICtonE
    jFJwQ2z1WMfZuopq7xsP7bhqzWNQm6egQR3CBR8qjAAAKKR+CAphQaCjTpQ9+V8lWipIFz
    z+T5luPENpjIy/sbsx8fgKQcA3GczUUkWzjH4xAApmPE7Lv25xX+OeEMqdf4+xSNG+Hcw9
    y53dz4TsXqrE8NtQwu9LsGn55Kh/dH+y3k3xnIcPu9jmHGdzRBuEpXuoW5pQ
X-ME-Proxy: <xmx:Ov3oatVmBUxAU-qlftG174ch4cUE1hPZUfbiGy-MXnyEedk1pTcvcg>
    <xmx:Ov3oalw3fn1STn5pX3nWFuGLmCSpsyEqsD9XqG3FpSQyidTSyyCBrQ>
    <xmx:Ov3oak_8xC6ybeArc_mD24S_41szfaVzMdEEEQb5fVtFBdQ660hO4w>
    <xmx:Ov3oaq_t2mGZch963X5gk4Q3E7u8C8I-uLBvYWNlibJ8pSfGbRo5uQ>
    <xmx:Ov3oajWxZDIE7ce7ydemNMmzwQpHd33kJibn8YFYMbiBnk88E2o8dXZr>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id E5D1F78273B; Mon,  2 Nov 2026 16:14:33 -0500 (EST)
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
X-ThreadId: AnCeav_jaY2o
Date: Mon, 02 Nov 2026 16:14:13 -0500
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
Message-Id: <f29a6aca-edda-465d-b6ab-9c7a5d7cddad@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-5-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-5-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 05/27] nfsd: factor out setting up the exports seq_file
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Move setting up ->private and taking the reference to the network
> namespace into exports_net_init() and dropping it into
> exports_net_put(). The procfs file needs them without the seq_open()
> and seq_release() around them.
>
> No functional changes.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>

-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
