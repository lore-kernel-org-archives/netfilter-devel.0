Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793879572;
	b=uRn0uqOjUxRjPtrJQYTSFmSKs5cAu9PL6nKofUnBtpHRPpCzqUD9HKVo2e9eeyf8H0qj
	 UYuPwQ1KIWpgPNjybitbfBB6Pd75rlicLq3fmsdQUdoMpGgP8Sxu1KziNJRgkoMhVh2w9
	 p/u9Gb/tsGlrSfbeR70bZtouLu1Pl4AzoxX2PFqdWbPjxd4TzG7yjPYCLqWe82RH1sTNo
	 gAhhztZ7U52YpF9SwmvOb50LnJm6yO4VZmpkKz9qGmtxb4Gin4DrOflUCVRdVecjV04do
	 1s4AXwlbF2FKAfvCwYmCsnEuatBgD4LjftNFGgZJtfli0WYyVlqc8CH6wyLqFlh/yhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793879572;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=0MWQ61fpbwQV/B6Gvwj4oi0aJVjxMYLJy0075lUkHYACt8RGKrSHoi39RcOw1ISROT00
	 ISAAdUJWzTjPmyEDB0zTD3NDzeTgb3bvrXNT150BsNzxhlDrw0iLl5XsmwSr4nuwUoDB+
	 H7Zt4N21lx0W6SaHSwIzYa1mdiSS5v2oq0QmLF/6TesPfubYJODP9guh8RTrHtFKokIUr
	 6gpA9G9ABO4e1CKSSwHBvHRCeAn4F1t297xyjmbENWygAX7GazwzMCKDGaKb0Xv5mjjwK
	 Y1M5M784EZ2pE4xbKzUZDo7Zp3/SVTxjDFN4Tq6XLhjKWVGKWBRihYx325PRE3Z062w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2A1606A33D;
	Thu,  5 Nov 2026 11:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B2A1606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IlDc2Fvh;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=vvDSWJYG
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4925621E8A;
	Thu,  5 Nov 2026 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793879570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=IlDc2FvhESlDd8QXX4z/a9lq2dVMhaxW+HuiTJo6x+4vVVqrVz8k3f/Wr+Mze0vHlceBFP
	JaL/+k/+YFdhkL/6vCq7Bg2Jyl3kffnaUQoNLw7CYQNpyydj2pmW97ukL1Mouho+skqqWs
	9mNCq/qpRDGAphiHFTSprMwCLm6e0Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793879570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=vvDSWJYGu2lVXhJVWrbpDbn5nEUGh3VUqLxrYRbdmdLlIIqOha94poMzPs0o88aMpXXTQC
	GveF9mKsY1fCOgBQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793879570; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=IlDc2FvhESlDd8QXX4z/a9lq2dVMhaxW+HuiTJo6x+4vVVqrVz8k3f/Wr+Mze0vHlceBFP
	JaL/+k/+YFdhkL/6vCq7Bg2Jyl3kffnaUQoNLw7CYQNpyydj2pmW97ukL1Mouho+skqqWs
	9mNCq/qpRDGAphiHFTSprMwCLm6e0Vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793879570;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XTBVvV1llMrY8oPUgGAOljMGttnFmdc1n4iSvCofGvk=;
	b=vvDSWJYGu2lVXhJVWrbpDbn5nEUGh3VUqLxrYRbdmdLlIIqOha94poMzPs0o88aMpXXTQC
	GveF9mKsY1fCOgBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F1468134F6;
	Thu,  5 Nov 2026 11:52:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5cjtKBFu7GoEAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 11:52:49 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 45F61B6C1; Thu, 05 Nov 2026 12:52:41 +0100 (CET)
Date: Thu, 5 Nov 2026 12:52:41 +0100
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
Subject: Re: [PATCH RFC 18/38] proc: don't WARN about a name that is already
 registered
Message-ID: <qaqawx4ajooiiqzu3ngxc46khpnq74u6sl5tz6az4uyssxzly4@346lsx342het>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -11.30

On Mon 02-11-26 15:21:33, Christian Brauner wrote:
> proc_register() WARNs when the directory already has an entry of the
> same name and fails the registration. Callers that pick their names
> themselves should never get there but some take names from userspace.
> pktgen creates a file for each device a writer of "add_device" adds,
> named after the device. A device can have any name, including "pgctrl"
> or "kpktgend_0", the names of pktgen's own files:
> 
>   ip link set lo name pgctrl
>   ip link set pgctrl up
>   echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0
> 
>   proc_dir_entry 'pktgen/pgctrl' already registered
>   WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bash/241
>   Call Trace:
>    proc_create_data+0x9f/0xf0
>    pktgen_thread_write+0xd9b/0x1780
>    proc_reg_write+0x1c2/0x3c0
>    vfs_write+0x1cd/0xfa0
> 
> The files of a network namespace belong to the root of its user
> namespace and none of this requires a capability. So once pktgen is
> loaded an unprivileged user can taint the kernel, or crash it with
> panic_on_warn, from namespaces of its own. pktgen itself copes with
> the failed registration just fine.
> 
> So go back to what proc_register() did before commit 6c2f91e077f1
> ("proc: use WARN() rather than printk+backtrace") and what
> sysfs_warn_dup() does for sysfs: report the name with pr_warn() and
> dump the stack. While at it, do that after dropping proc_subdir_lock
> instead of printing a backtrace while holding the lock that every
> lookup and readdir in procfs needs.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index c560c96a64eb..ef804cd3ec45 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -401,9 +401,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
>  	write_lock(&proc_subdir_lock);
>  	dp->parent = dir;
>  	if (pde_subdir_insert(dir, dp) == false) {
> -		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
> -		     dir->name, dp->name);
>  		write_unlock(&proc_subdir_lock);
> +		pr_warn("proc_dir_entry '%s/%s' already registered\n",
> +			dir->name, dp->name);
> +		dump_stack();
>  		goto out_free_inum;
>  	}
>  	write_unlock(&proc_subdir_lock);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
