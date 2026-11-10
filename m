Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320380;
	b=JFR6l95J84YQccGdU/PiN56TOizfEGjL6OGyWW4N4fQYz9K9ueON70SZf5TdSAsfO519
	 APfPVUP7Z+b1v2flshQ+twfwQgSIC4YL6VUKYitqktG2RRBY1pqDBvZadUpL7m5jn2VP4
	 72CU3ooklhptgzyCgD3g7B/e0nwTa/oEATvh2m5QQlWYEAnjULuymULD2lv8aYYXXNdhO
	 6u76Aa1q78MBltLcr21nz1zm/ZmIfS1cv3GrJBDVacloWS76m3Cu27rw5sS5UxHBvAN2u
	 KqBj9GF3oaB4dRJcLDkwMkOFe++fiY+KlKa/7reHYmz4pUIG5C9+0s6DMmsuWiXTXlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320380;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=bkc2xvu/oS7jkyiRl13UQfET4/JhxuqXfaoJZnlX0jhiEiuXLTTJZBocmDCZLU20JWgW
	 0Y5XX2Pxhlz2L2u2pzOi4mPcmaRm6vi6cPFmMFZ++ZVbWnaLZKq2HocH93dHhA8OT65uz
	 YFBN0+zjpGDeMhQC8/FhclE97QM/pjzHbTy0Uq7qkzbHkcP0pJCU23I8B5SG6VxxHp8Xd
	 Rrhgq38p2j35945InRprycPWMj34DiX7nFOi5or35e1yyQabCRR2h7FRqtrd+uMjLVpti
	 USvVGo40zcs/J9UBc2uvuw10tXLLRKDGVfUHM3o6/Sdh26qtzQRooyeB1bgkyBsnSfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZVPXUmC4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hlc3f2E7;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=24m00Mxy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gWL5bCh6;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD7660A2600;
	Tue, 10 Nov 2026 14:19:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5DD7660A2600
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ZVPXUmC4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Hlc3f2E7;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=24m00Mxy;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=gWL5bCh6
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A6CE81F769;
	Tue, 10 Nov 2026 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=ZVPXUmC4mGewMANDq+XWqMfufiC34pXna6eT0w/isfdeZ5z4jQWmJ3C5blgfM/blFxbxRi
	GXx2I6Zj1FEb7O7GZyCw3PQ9vVoHcaTlnyF2iDNG/b95INh8IAF4Heax/yxvfkvdjUes86
	ZeBBBpN/JMM61PPOsv+BlSE1bUf86L0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320378;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=Hlc3f2E73UolHpexWZ0OEqOYGnAZGJUiTOZcmRyhsLWloTpsXT3IbdvFQy181tx+6xfr/R
	LZMnMJkUpESuzgBg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320377; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=24m00MxyS14C4kCTYYtxKWJP25EBVNVIxLRshWhDnl2XZwRpRipDNZJw4Avu/J2svsqCMy
	VTYT/SHAlqxbP0FIU7B9V7eV3/1rBXkEe/Lcm9f8ja9SENmigoj1MKRmnopRtQWBaY3OFh
	eux20BDfQ6AJqBojuMAzQiJJg3QKDxU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320377;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ey86SkVvx7i9NDOgarxUx2o/w+Rx/Wx0u51qrIOGmpM=;
	b=gWL5bCh6bmxfDaClyKTxrGr/cthAMhYHhVBSAgTvyrROUNgpSm1do5CLIUVQzQAzFJlTzk
	zIhImlSyPcZvZwDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7A2B2134F4;
	Tue, 10 Nov 2026 14:19:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nYVvEPkn82qNGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:19:37 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D0CEC22536; Tue, 10 Nov 2026 15:19:36 +0100 (CET)
Date: Tue, 10 Nov 2026 15:19:36 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
	Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Eric Dumazet <edumazet@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
	Greg Kroah-Hartman <gregkh@suse.de>, Joel Granados <joel.granados@kernel.org>, 
	Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, linux-acpi@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	netdev@vger.kernel.org, ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
	coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
	linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
	sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org, 
	Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 29/51] proc: don't walk through a non-directory when
 resolving a name
Message-ID: <okuebbxuf5q6xy452dlnxaqwainsafs5waulvn54j3vqxg2dhx@hh6ql7sg3pte>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-29-bbf7d5546809@kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-work-procfs-bugfixes-v2-29-bbf7d5546809@kernel.org>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-11.30 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[60];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Spam-Score: -11.30

On Wed 04-11-26 18:47:15, Christian Brauner wrote:
> __xlate_proc_name() walks the components of a name like "a/b/c" and
> takes whatever it finds for "a" and "b" as the directory to go on in.
> It never checks that they actually are directories. So
> proc_create("file/x") hangs x into the subdir tree of the regular file
> "file". Nobody can look x up there, but remove_proc_subtree() on the
> file removes and frees x along with it, behind the back of whoever
> registered x.
> 
> pktgen passes the name the writer of "add_device" picks to
> proc_create_data(), and only the part in front of the '@' has to name
> a network device:
> 
>   echo "add_device lo@"   > /proc/net/pktgen/kpktgend_0
>   echo "add_device lo@/x" > /proc/net/pktgen/kpktgend_1
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_0
>   echo "rem_device_all"   > /proc/net/pktgen/kpktgend_1
> 
> The third write frees both entries and the fourth one makes kpktgend_1
> call proc_remove() on the freed second one:
> 
>   BUG: KASAN: slab-use-after-free in proc_remove+0x8f/0xa0
>   Read of size 8 at addr ff110001134c8e70 by task kpktgend_1/243
>   Call Trace:
>    proc_remove+0x8f/0xa0
>    pktgen_remove_device.isra.0+0x118/0x500
>    pktgen_rem_all_ifs+0xeb/0x1a0
>    pktgen_thread_worker+0x1b42/0x7280
> 
> The files of a network namespace belong to the root of its user
> namespace and these writes don't require a capability. So once pktgen
> is loaded an unprivileged user can do this in namespaces of its own.
> 
> Treat a component that isn't a directory like one that doesn't exist.
> All names with a '/' that the tree passes in as literals only walk
> through directories. pktgen is fixed separately to not pass such names
> in the first place.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 4c3fcaf68ef4..6ac9c4c13897 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -170,7 +170,7 @@ static int __xlate_proc_name(const char *name, struct proc_dir_entry **ret,
>  	de = *ret ?: &proc_root;
>  	while ((next = strchr(cp, '/')) != NULL) {
>  		de = pde_subdir_find(de, cp, next - cp);
> -		if (!de) {
> +		if (!de || !S_ISDIR(de->mode)) {
>  			WARN(1, "name '%s'\n", name);
>  			return -ENOENT;
>  		}
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
