Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633074;
	b=SX/diNGWlY5n2wfj2QL1EBL3ckViy+ZyNgN+4AnWXRLdz3Dkt2h4/lNXbIehpqnxAfFl
	 KvpANtAMPSQNwo6g7pR7P6qb6EJhvzwbWZUiXOt9Z6oyjJkcoVwwcK5xwpYuw0PeDYm+e
	 FAZD+LUj/GbnywfGoHemaz9Bkc8fKRs0/EdUrj+NX38Q9J+cXruzr6JkmWIHP91a/S91z
	 VulFa033pCNNdaxOlc+Y9M0hoYr3LjIiqrf/YabWvK1v82WeCLIKsCpaILdizN4tSbUj4
	 7NS3hu91saZbhYTj9/Samle1o1evdtbAGevEEl8Bu1ki985tMKatTzFEiloL0SJ7RLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633074;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	b=spAXBCxbQHleKyhifvohJEd5jTb+sF7tf8eVj092LXeuSKIBj/AnUyqxZImJGrggkvKv
	 iXR+UvDfeL4HsHBTcE+GpX53gRyR/M71grHytDxBSUyrHdvvMUtfLuTaEUuJG2kEBMJvZ
	 maaSSghjkFuEEUYnGF4rleZJPcHaUs4OPoQbuskx3rPAIuk2yf0G8d+OKmQG9MU7mng2K
	 pzzEsbicnT+OuUvOt4dcuk5tc5MgR7dX5g9ym8ttVehGIjt2bAJTQq/d+QCG9ilBicfBg
	 mlqIrHNTkReGNDYF3lfrhQxz9abOw0i8Nwo0w9os8q5PUOVcmrZTT8QWvx5TfeU9QNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ar1yBvIC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39932609817F;
	Mon,  2 Nov 2026 15:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ar1yBvIC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CE71F00A1A;
	Mon,  2 Nov 2026 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633073;
	bh=hWdxbpN4QmmVdM7UmPZX8KG1qjYZ0FQqqjiDA/VJnOE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Ar1yBvIC81AlkQxN0d8lM4DpCwZj6UD5Vo49RyJQFjBo+C5808Pq8HrM+wAoBQjA3
	 To2qlDBeXG+6aWhFfzFxckZhBp4wkxGPed1kzaSFy7pAwQvGhVqrlWcgSO83vhFh2X
	 VguJsl3FOT6CuxR1TaO4VAkb6e8ruEaXIJCPuttwfEFk4Yh74hFOxeUwEBHI2DG65H
	 wXC3Lg/pvX9tz3gCYyulsI43Qty1XcefEQ5+MfZo2VyAYcESwo98NdtxOXW47SccWo
	 0pNgSCt6egv+4aFZrmrWwjyAqZR0twQlxJCFZhysOjpyNrHyg6qoh3yphtMMZmOs2i
	 8eby7zmG1MLKw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id D2705F4006C;
	Mon,  2 Nov 2026 10:24:32 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:24:32 -0500
X-ME-Sender: <xms:MKvoavSKUiqXlpmsbk4x_EzLxRROHSR_9BdLdFDueZ3aJRiH03Kj7g>
    <xme:MKvoark1e7oBzVB6EazGgyrtPDptmOfDem8ClEXKKWNQExwA2Ij7Xe2VN3GxRNGuJ
    6Nb0Vjmr7Yi9pyc_zj52BUYSYBkOd4VYwbZets8y3ullc4HaW72Vhk>
X-ME-Proxy-Cause: dmFkZTGtfrsnUprxkF5qguts9aGoe/r+VjuJA4ciTNBlyoDayaXNLufHqXhA6kBrvL/iAr
    3wgAuuQGiHEv3hnNXqMyWwUdK8YFm1/1GrsjxqWJn5YPeS+c8oPtRrq1CDaj1biBFdNRN1
    4UDFT90xsu5mLrQncUNY4oGNWjrFklK2K5oJ2MwxzwjSIyUfh0eQ+uCGR4Ad/x9dt2ub0M
    BWqUWU6DkiQJpaWppyDq8vWSYeYF8lsBRui74VDWdPCyh7aOwC/vKR8gbfdjBuW2LNuh38
    pOYiauMZHD5NvCm9QOJGIhVVM7YyPBnQCZeRPCgGSrnOrifD8zqjkAoefxHqYsUlz3W/c8
    2gfOCAstyw+OFvae7dc5IVKqvvkOF9OK013F5PDLVpnUdMTyNDeSDKTO+Q9NHexjpfHsZF
    tbKZF9Rf7RIf1whsHXLWLjMq+b4ZyeDSBs37NkdVKK+HwZOoTwdKbzTWAvsGbubVSxyBjR
    9mIJqTAVebgWOhe2j1nb/URiMOWpqrzT0jIir8ZzZC89tAvIKTZPESaSS4Twsu+AVwQCAC
    uJSAyz5JSjxyY4Er8OphrQKWXZ01QU0bT9PA6zml2ntbWClyL02iwuKavM8o4FRKL/uVIz
    BvdNGuuY82Haqtc0Sse5GZBDGcsxwzOmYAwZ9InALDI5bzNks9gPWh04Lhsg
X-ME-Proxy: <xmx:MKvoahT_D8YEi8z1Kc6jMTmDVT8yaom17pznx8st6etKxvmXLo0tNg>
    <xmx:MKvoaqdV5ruPp9h-q8Pz4Hcw8MEfRPRbjyB0g9BJmWVZgqN_7ZRgXA>
    <xmx:MKvoaicIcxzbsGdb9rhBgLYqyai_zpFk4G7MzepbewkbW5yImYgZGw>
    <xmx:MKvoak3Gj8PwbUG94UEsXjpXzmTdvm836urUlCGQLL8cRHx2S6OG6g>
    <xmx:MKvoaq9vQfzYe9eVwTQevoT8-FLqc80cjNDV0v5kJcoDlScaHfwgX72y>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AE2CD782738; Mon,  2 Nov 2026 10:24:32 -0500 (EST)
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
X-ThreadId: AG7Lg66T4xgg
Date: Mon, 02 Nov 2026 10:24:12 -0500
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
Message-Id: <097f592a-d943-4740-b99b-8983527095eb@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-4-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 04/27] lockd: let procfs copy out reads of nlm_end_grace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Implement ->proc_read_buf() so procfs copies what is read to userspace
> after it unpinned the entry.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
