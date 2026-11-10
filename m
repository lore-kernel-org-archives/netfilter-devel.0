Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320761;
	b=EcSlTZ0c01JM8gmRyaPOsBV8SekvERDvQx5Uc3srzLISQH3AyP18BeRcGmfimkT47CC2
	 YXHKRoQ5jKAMmCtQV342W4tg5Q8aoQ3uNmF6Q9Y19G8Is78Ic+CNUo7m1aNMH0hHglAsB
	 AAKuC5lV9k9PZoCqx1PUP0WyC7v03nrqmXNKZ+glngS0DNaXzClf6OlxmJ4EvG68/viuM
	 LnqTexvl2zjkcmTgZMM3GRHx5uGpa3UNEgQaYOiOX/OclcRh8n2qbC//HuBxlnwJy1HRg
	 b6NItQXfojgjot5s3sweHRiyg+tC3ZblHIvHskKwIHcFBL2/UJ8sQLZkjjucoDbEORA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320761;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=egXnEsCvFmBMqvCmv9HH9kd8vJnrfJ9Ue5/xXI2nE00=;
	b=AnZk6LL65sBnQTZixtQ6ZCzMtP2mJtAwwqXw+QTw9jcICneeVCgYMq+dtrWxWIrIk1g1
	 5vqMwMD8EUUoqewQxvMwFSsxIQHgYpnwNQYqzCxI0bZ2QQNpkSJ9twQMJ0fGM68hSvibR
	 3nUS4wvGHG5NsUDOxMtVYBlhxk5KM8hy6nK+UPOaZqKEPINvQ+ydPOvBNh7dlGrc/9TzR
	 89yeFd94r3nsBZi1vlvbziGpuguNb8iJpLulS3RVO4+V6whu0OEtUnehxO+AfMNjI/ZSO
	 sFbXKoAr6YDW4fTZnuiGCXMS6RHSJIo9JU1ICas4/ZqKxyyRdWyg8dGwlJ+e4TfDrbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oBjhitk8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="Vw/QVACF";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fVAUQ5PS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BO7HZIVN;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD720606A334;
	Tue, 10 Nov 2026 14:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BD720606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oBjhitk8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Vw/QVACF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=fVAUQ5PS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BO7HZIVN
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C642A1F7E2;
	Tue, 10 Nov 2026 14:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320758; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=egXnEsCvFmBMqvCmv9HH9kd8vJnrfJ9Ue5/xXI2nE00=;
	b=oBjhitk8jFawUrkG05h2U2d6qwNNErd89Rhw+PJckqwNXkTk3zz2i4ttxLTeNMd86D0dbV
	1fmCUmpnly7cZTk1q59ThNg5qOHP9m1hxXj66TpO7swZ1BE7LjuqCeUHRH0qfMZyS0RfcG
	iNlsaXvRZgtEcjBJefoFd/G80sUwmZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320758;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=egXnEsCvFmBMqvCmv9HH9kd8vJnrfJ9Ue5/xXI2nE00=;
	b=Vw/QVACFHDjumXdMruYOArsE9+Vkzlfz9qDVwyjI8jTYCyy0mJZn5VEylbXtrRedkBw2Ar
	fGLZmMkLtcoQMSDQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fVAUQ5PS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BO7HZIVN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320757; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=egXnEsCvFmBMqvCmv9HH9kd8vJnrfJ9Ue5/xXI2nE00=;
	b=fVAUQ5PS1m1D6ItuWR0tToaFJhyYQSNhZWwN6OqatIifxgMCS60C9O/EXuS4tXyW6iQD5S
	c+V0Yn0Yhw+0nmMGn/2IEKt7bXYwwc85ll71tD+bDqaPygxea+ZjBJNsODcDg2GlSr/dDm
	BtvTPuWmDogO1FcX2wJtc/7HNrmF5vI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320757;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=egXnEsCvFmBMqvCmv9HH9kd8vJnrfJ9Ue5/xXI2nE00=;
	b=BO7HZIVNR5RJE5+j39tUZK0aKhE3zAQvuFbgCP+XYeYJtTHzV7vqcshc80DAYsckGjLJ3h
	Ejaj/NAVW6jsgcCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8714313479;
	Tue, 10 Nov 2026 14:25:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HIGNGHUp82qIIQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:25:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C3D822253C; Tue, 10 Nov 2026 15:25:52 +0100 (CET)
Date: Tue, 10 Nov 2026 15:25:52 +0100
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
Subject: Re: [PATCH v2 31/51] proc: don't WARN about a name that is already
 registered
Message-ID: <63v7hayet7xecsfpueywjg4zhpmaalzrgpak4rxycvui75h7tj@klvxoibaltdt>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-31-bbf7d5546809@kernel.org>
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-31-bbf7d5546809@kernel.org>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email,suse.cz:dkim];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[60];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: C642A1F7E2

On Wed 04-11-26 18:47:17, Christian Brauner wrote:
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

Fair. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/generic.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
> index 6ac9c4c13897..9e59796349e1 100644
> --- a/fs/proc/generic.c
> +++ b/fs/proc/generic.c
> @@ -402,9 +402,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
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
