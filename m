Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069981;
	b=UsQ6Xne5uteaKgr0Mk+VDvKz2ySdwT8D+RiHXELZ4BfJGlG7nMfGIZw4uWrpK9zHwlzQ
	 6WrQefwGo+LZToMkdNKM5wMEJa8hD9vS3J3Xcz9z4xPedEwZdOSLC9VIO94uVOK6cKU6q
	 OcR5+WzRKrXMvaqAHT4oedupT0SuplgSE+xRZgWrzqtwww8Hic+fc7mJKROVBBMr2x/ov
	 NiwACDYUshPmw1WGYLWWYhzukQ4DJ2dqZDRBsLsl2r9oOOo9jgTbTYn9CMkNezMZZPnrB
	 TknMUv5a+jaEWxVzRC8uEoMXODZgJKEWwi+qN/hkd7q2F6AdwjO71XUtzBbdyGnmUcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069981;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	b=v7wF209hoERrDgjFwANIMrIRvimQbbj474nPui52auGW5BxluofGM6z4EJfOLBXkPsnR
	 MTPk3jNz7X4guFQDBR28t2uG6Od5YUQuY9uP04OC+8pfhvsY2wefsHPsMnHwCrUIBrjbC
	 YZwPlboaITtX6Ava/fR4AtRO3Wv7TAKn5HsESpR/axheMDnmArBRrOMELdbDpFbo4/kkX
	 oi1IRUTWtIPdmxn+xiG1LpHXVP7NdBR5uOZn7vV7tTBJ0dxgeiqdJDboH4DP1fUeorlUQ
	 Mnx2MgCPgoKTyXlPtrZbJ6WcDbVt9/UuoAhWoxjooXsZA0MaBC3o0OFeztayfHBIliA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdchM4JA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16FD606A326;
	Sat,  7 Nov 2026 16:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GdchM4JA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33F3B1F008A3;
	Sat,  7 Nov 2026 16:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794069980;
	bh=iQPFcguwJfJnGIUghj3vW2cnp0ZTKsyoI6OiYKG+trA=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=GdchM4JAcx1qo6towHdQHCgh2tMHo3zzg17T84D+E9tEQ4saStJy8zvHY9EwNQyxR
	 oK8yaLgqNU37R0MQlKrJvaZTfioOKst375+EE3LbYI7gUQePChwprYDcMtej1nwiGU
	 dsufOCJUs+IgboNeWUzJfOUvnLV/mLmPPAxP++XxBwWdSvsRbSF91P8JnlzSeymBlh
	 lEzS0bCVLtim+6ouaGlrDE6fsFvc5qFqfvhCWl64VQwoWxGe8sefwAjw7/I+6jcZC+
	 /WKSC7uAJb9FKzTFrIsSEdraVR2Eq0psBydCysFViOt9COyNjQJH1jVYaRzZxwoY3u
	 vZLcyJogV9A/g==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 770BBF40066;
	Sat,  7 Nov 2026 11:46:19 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Sat, 07 Nov 2026 11:46:19 -0500
X-ME-Sender: <xms:21XvaoI8xVkuzu2ggxmfT2VoL9otHZIhGkdP7sT7nnFaVj7_NCZbgw>
    <xme:21Xvai9jvswL5aosPOj2sjBdsne--z2Vcw9CybSvH6cV4Z7_VedZPDAPFFm2w_uB1
    OOHRpQdMcOvh9FQ9jewIohgBu8C0-FJ_t7pVgQmYakS7uvE0DqdnYj1>
X-ME-Proxy-Cause: dmFkZTFtOlailLA7ZjiNgBTvvRwW+fQs0xcHo5AHr7fRtJrIuFWMuFVGu4oQuCeZ0pr0pC
    lj/WCGWUBzDoQrKdmeOIOx622PB5FBwnR92PlS1DrVrA5uW0MnsNHEpSCCEISbjWcBNWpd
    AJGAUrhAP2ixHqxr5ktjqtDZtDRxQ+wxwdXnbM6ymNuxLXWUu5re/DshCdypVN4RJVSYiI
    pX6xC2OVQ0adGi3NIKU3V3E+k0PR9F5sS1Jrk8VpzWhAMrFUcs3GPG4cWRftcOZ2GaObQm
    dtFuqB299Yev5WyoldQClGgN+jblV8xsVjLfVWhN2y4yGtMahzOezGLQ8LrNpUxR8dZfbu
    lIypd5PasUVA/oQYiP1JJjnE0dbtceWFuNu/cXjVcI3peKzIbO94dNfJzf+KPUBbBj6OJs
    xONTmDWVPcnavfLGnJ9Str1iCXWjLd8n8plei7GhfZ2Yct1Mb36p3Ftpqsy8HiFzlFB6JR
    vCDf5AqtF24I+Ixh6htHYnxAa1boUFkUM/E/HKAo3rcBd+9kTud3Md2a4DQbfiDrY+cerB
    BCLBcSU5xi/5AvO8RpQ0ihQUFVAFkvT394aMfNkcrcyvDmaq3pfLyB5Len7h2/bmpF+8sx
    FrsAUEinhV76Ec3u6Qe9hQY0Pq0UexmL2UqEZd4qhrOC8BGG20S51iSoFmYA
X-ME-Proxy: <xmx:21Xvatt0Wu0fKbN7TVc00SVx5cl4nBo0Q82lDLMniu-fjrCmVGavWQ>
    <xmx:21XvauqT1roSxPVbJ__cvWOICXpZBt0Uy7t30skmPBgH4PUxXx1_Kg>
    <xmx:21XvasX4cyeQOJfObf8n0k85OhQoglMXW2ST001O3cCOWy0j31aVlA>
    <xmx:21Xvau1v9osh-1HQCt_nNNhBn8zDdcUV3_YpTMTutnfhDXcPKzQcmA>
    <xmx:21XvapvZRqwLy9j4pgfhYCEDK1_0cwha-81FwJc9sq3a-mW19BlYyiSq>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 5E62D782738; Sat,  7 Nov 2026 11:46:19 -0500 (EST)
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
X-ThreadId: AjxZksNfZZQV
Date: Sat, 07 Nov 2026 11:45:59 -0500
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
Message-Id: <a1e2d05f-08c6-41ac-a8f9-6985ee00dc97@app.fastmail.com>
In-Reply-To: <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
References: <20261104-work-procfs-net-v2-0-221e2437fed1@kernel.org>
 <20261104-work-procfs-net-v2-10-221e2437fed1@kernel.org>
Subject: Re: [PATCH RESEND v2 10/13] SUNRPC: let procfs own the wait queue of the
 procfs channel files
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, Nov 4, 2026, at 4:13 PM, Christian Brauner wrote:
> cache_poll() sleeps the poller on queue_wait, which went back to being
> a static queue so that a poll() on a procfs channel file can't be left
> on the queue of a cache_detail that its network namespace freed. procfs
> owns the queue poll() uses now and it outlives the file, so the procfs
> channel files leave the poll_wait() to procfs and an upcall wakes their
> pollers through proc_poll_notify(). The channel entry is remembered in
> the cache_detail for that and forgotten before the entries are removed.
> The rpc_pipefs files keep sleeping on queue_wait, procfs has nothing to
> do with them.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
