Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793653906;
	b=iGL7gUWQk3g6DXh0SwMASLul2JP6hxXu1zazD6wzDDpkUzk0pHDLk72mNNRafj1LTszk
	 zlwTrBuWQ0f0fGbXhMLO3qK9an3akPhuOuMmYYmuIxNB6pB04ez1vDq8G9Q96ZSGAZvh2
	 4QRAHCltSWW9vzLwjb+eRxS2n35bbIYEQ2QPcaZxE1OYzA+LR2+poFYDkZGVswt+V7XhP
	 HijSZcAH2ZcNmz54UIVZL33Mo5wnbXKAD8n4pXdugg92KaXBolP5LR1Q7RcF6TAlgoF9B
	 fdc1VaV54NgHaSAozWGu3/u8FVUhIzAdxtsIoYoXqyhhjUoZf4L0co+ysDIbWKkKbCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793653906;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=xxWoHxsw4VPFqHPAqACZbusTmTkHUnFSnkXXJwnJ4WA=;
	b=DFJTc1CEvVIBsE/vDp8FgdYWBusDQZHFflIrh5oW/B32SZLIGQe/MLZMUSFRohzpSU2U
	 xktzhiRHQ5SNoX/FLja7Diuq1gcdHE3UtQTkXK6Nq0OERx4vpa+G2Ww5cuL9xIULnvD3h
	 y+IFIc4AxDg4dqPSYsOxaL/9xDSfS5m2zkY5J9FtMxLZ+U7la9gNCnmz0OZTmNMAiZHyx
	 Gz2MoyzXwSTqpYg4XTdf484CQXDUjGN0sTtN94DawulSJSjyDgd9l4K9YRIZV3n9PBlvz
	 xTrxEZPMOrda1QqTGCvzAsKlorCC9BUbUbkbci++92fUGXEHEQbVVbL7p0GJLU9PkWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZe6+tyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB1D606A329;
	Mon,  2 Nov 2026 21:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XZe6+tyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F96B1F00A16;
	Mon,  2 Nov 2026 21:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793653905;
	bh=xxWoHxsw4VPFqHPAqACZbusTmTkHUnFSnkXXJwnJ4WA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=XZe6+tyYLswAenBO8yAzFdeWRzKxvbqg1Ev/mg/a4IY5Ykl6dyrcjlnUec04HQhAB
	 wUqBfr7XNAis1gRkRlwuGTTv/aLI8n5inKL/pOeo0qX2ZMVH6ZsIHjb5NCZh9zUPL2
	 o/ohakMyhEJMO6zYmevE4LT4/D6JmGaT3h4w7BN89zF2VUs59WIhKi/DP83L+kUnC9
	 SsDT8nIZxjYMyLxMxFoJC8PTJcen/wSXsZsrKVj0Q0tCq0A7kxVFkRR+wzfD8le+If
	 Wl/DtyEEVNWoCvyuUqF5srUDKOCiBW/Gb9kIb+nJ5eqrm2qnqAgrPwEWkqx/H5R5yQ
	 Crn9JOHwAhkOw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9A2D2F40069;
	Mon,  2 Nov 2026 16:11:44 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 16:11:44 -0500
X-ME-Sender: <xms:kPzoauT46RzZZAtJ9pk6EmeQC8cMELBagB3u1iMeAaHmOjnENab40A>
    <xme:kPzoaumk-opmRQlpeWeKnkRMlTth_z6pBLrv31d5JNfpKtehryrVtBuG3qfafkapL
    0UJlxT0ifcf_WdI3louCiTK_NZW_9YRI03kfo2jNxtQamFkpy63zY0b>
X-ME-Proxy-Cause: dmFkZTGGTt1pQq16zbZlBikp5z2kGCzhIzyCgkLQFgSXoffQhlPZQXfjBFq1ZiXvdSuuXZ
    LGfrLfwbRgm8cT/TQHLtmkS2wq/scJf8NlSAUsi0B9JpHEGQcArw2onxUgxSVXeSq73Th3
    +MD0Qi/P+BTULU9VUvoeDDNpVnNmDbD7jQoN3v4l/IoJhT2uLJVTZ+qQoBDMXBdvnbBuoB
    9tDR+if4J7M64uHI42/0BjtEfvrRTVsfVuGRQKjlc4H4/Tpb6Ukdvkgbe36C9jT+yX7xq2
    jBGJCbh4CPX6idD2imiKQ6v9tm9bzRUVfoBUnOyYFMrBkFYiOOBWgnG0kr7aHqxli45kQp
    ohMXmtjBzal9CB+YgOYOkiE9b51wZucg/4Qex1khPYx+JLGLu0NEFrvGtoRmQ6eE2VafNW
    CY+B7UtOu2dLLX0YzJKc7HKLrBl+UhzkRfMrCHLaMOitCefJUNU2mkw7vcohOcdeMVRCgw
    TQWRrq9hCVC/B8Rxe6VYHSl8gHOGuRazDUmW6qr5GDwgwEuKJT0vVpSDws8RN4u7/JR2Bw
    7Q9JGl1Z/LH2lgcMAQgF+wjiqdsKo0vCxpzH21ZsG7KiWO33lqILFRfkvZC562OP5TxBQG
    hvqFJiKnoaGgu8gvbQah48jOhQq3KspK10b5m5ASEOwP4kkYmm4PvM17d+KA
X-ME-Proxy: <xmx:kPzoakThPn76RnRib5bZ_FntPITCT1o4Ovwx9E8rstI1voUg5JpAIA>
    <xmx:kPzoahfEU2tfoiygDyUOVgUPLZrN0jZ-87YF5q5IhIxNwkm1ztvL0w>
    <xmx:kPzoatetgw6gOoAhlTHOnt-HZbmjY916FiHHIyaUhhTihCSwAOX_gA>
    <xmx:kPzoaj1ywieDU5FAFn3LFQMJapowgQlEbMPUeurA4l5-zBDlAnyByg>
    <xmx:kPzoat9Ejs2zX8NiQVdXzLsXpl7UKGdgzTPDTECnMqAK4pso_NRi0RMI>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 7098678273B; Mon,  2 Nov 2026 16:11:44 -0500 (EST)
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
X-ThreadId: AFgPYeWZplpR
Date: Mon, 02 Nov 2026 16:11:23 -0500
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
Message-Id: <7ee779f9-db3d-4829-bdd8-1d09e3f74c43@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-net-v1-6-982104a4f592@kernel.org>
References: <20261102-work-procfs-net-v1-0-982104a4f592@kernel.org>
 <20261102-work-procfs-net-v1-6-982104a4f592@kernel.org>
Subject: Re: [PATCH RFC 06/11] SUNRPC: let procfs own the seq_file of the cache content
 file
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Declare the seq_operations and let procfs open and free the seq_file of
> /proc/net/rpc/<cache>/content. ->proc_open() and ->proc_release() only
> take and drop the module reference and set up ->private now. The
> rpc_pipefs file is unchanged. Reading the procfs file then no longer
> holds up its removal when the network namespace goes away.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
