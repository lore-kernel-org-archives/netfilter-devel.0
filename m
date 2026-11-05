Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881462;
	b=oOo6lE8Ftc3KT/7sB4G5eVg9hdgSwaxXCBETfsS1AJevbRij7b98V/pO0fsuXPvN6my0
	 ia+CNl+FNkthWlTrBJTSNNapNzapFb1Br8yPJP+xsdNQZNtrGrs1Qzs9n5qyJcKfl3wUy
	 sHLst3oN4EqmqYGBW3ItaFeAkKSty0blp/3oT7MrY7aNMn24DkfOvjGJTdZ4YQHC48eef
	 qd+zpRu2t47rfCB9cKvrEd7kUrfS88GArut0OVZfV6FpJEmR/TXhGmhb6kW0rPXaO/LHa
	 I/TCvPCZs8qJwmCoLktePHwgL6e90aINNuM+zPNTtZ91tk+jHx3hR+XoYZHMBNb204g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881462;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=KAJa1IfrIA1lNXIgjD80F2dj9Y0N1kk6ciL/YlWeV026mLLEKOrzZ1tZ/ql755x5O+av
	 AOZgT1rWe69OvhmK75rfgJEkGFTXGqBYFMimKSSB75vEJJU9gwb+9HdB2jGBF+r33HONj
	 4pW9AUj8+yr8QBNaGB0bheHWX/vWEZUn4LtFEV2K5HjNBVKMAoJ52jMgxF99EK0pNTz3J
	 B7+0cvVJc6brZRB6fcP33GceXm6YAy27u+wfgtTowj6CchFtHTyqC1xCz0A7c8iF93L8G
	 tGR+k3Xt+ajItW1GE6HObY1Fad/ZsQ8tTDKbzbsKYM5nyAdvE2ZJSxNFa+9FW/Mm74g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=PCr9ZQmx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zx7+aO1b;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OA7rJSNx;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09E5606A31B;
	Thu,  5 Nov 2026 12:24:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A09E5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=PCr9ZQmx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Zx7+aO1b;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OA7rJSNx
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CECD91F825;
	Thu,  5 Nov 2026 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=PCr9ZQmxJ1QHKzVbFide62XSTQuBL6wMyZ4ixgZonrOq7qO6Z7+mMaPhQmH6K8idF1AXs8
	0dx7Ptuknz/mnEi38AADm66kn20F6q2YV44iThgkzuPEOJyH7BuDZb9IxT2GDZR9E41ZX1
	OpwzN7CI0fdifDWvCMxvxjoduXA3X6Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=Zx7+aO1bN5Xl1IHapdl8fOmPBt0pa7X0oRYDzk5w1JovAHisW/PfVfacjBCbAAzFFn8yQ0
	yE8fdIjekv9nMZCw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x9Zosn4E;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OA7rJSNx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793881459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=x9Zosn4EbchHGeE5udevL1r29rgPf9Y02dysOElisjHj+VO5UilfwMafmPydaCNnTjwNzv
	UF86KGWPiD1Le7Ah5EEn+d+JCboYs72l6yBZbRCo6mTyh4eKiPufQjAAHaHoFJVIZkad7k
	Ds8jF1cavCxTYhTDUloFMVoekboGBwY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793881459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qZ2SbYk3GrokaaO0nBX/KKA3dRohO53XWjNLOWBHmzM=;
	b=OA7rJSNxuyCmeklmiqZ15Mq0PWDdCAvs2gjXUAdfvq+IV2EYP6LI9FD76bFqQPglYJgSmh
	0coVcjc/QUeRzhDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C676134F6;
	Thu,  5 Nov 2026 12:24:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id LsThF3N17GqBIwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:24:19 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0060FB6DF; Thu, 05 Nov 2026 13:24:18 +0100 (CET)
Date: Thu, 5 Nov 2026 13:24:18 +0100
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
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RFC 34/38] proc: sysctl: look at the table under
 sysctl_lock when creating an inode
Message-ID: <tmxt2djcskr7qa6a2ewpelbhnyxtd4xp6dabc2uq5cdea5xdex@qn7wcwyjf5ah>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-34-59422ed3e465@kernel.org>
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
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCPT_COUNT_GT_50(0.00)[59];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: CECD91F825

On Mon 02-11-26 15:21:49, Christian Brauner wrote:
> proc_sys_make_inode() checks under sysctl_lock that @head isn't being
> unregistered, lets go of the lock, and then reads the mode of @table
> and calls ->set_ownership() with @head. That's fine as long as the
> caller holds @head in use, which keeps unregistering from getting past
> that check. The next patch has a caller that only pins the memory of
> @head. For that one the table, and whatever the owner of the header
> keeps behind it, is only there for as long as nobody unregisters the
> header, which happens under sysctl_lock. So read the mode and set the
> ownership before letting go of the lock. The ->set_ownership()
> callbacks only look up ids in a user namespace.
> 
> No functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_sysctl.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 2150cf842919..a1242247f492 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -500,6 +500,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	struct ctl_table_root *root = head->root;
>  	struct inode *inode;
>  	struct proc_inode *ei;
> +	umode_t mode;
>  
>  	inode = new_inode(sb);
>  	if (!inode)
> @@ -509,12 +510,22 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  
>  	ei = PROC_I(inode);
>  
> +	inode->i_uid = GLOBAL_ROOT_UID;
> +	inode->i_gid = GLOBAL_ROOT_GID;
>  	spin_lock(&sysctl_lock);
>  	if (unlikely(head->unregistering)) {
>  		spin_unlock(&sysctl_lock);
>  		iput(inode);
>  		return ERR_PTR(-ENOENT);
>  	}
> +	/*
> +	 * The table, and whatever the owner of the header keeps behind it,
> +	 * is only there for as long as nobody unregisters the header, which
> +	 * happens under sysctl_lock. So look at them before letting go of it.
> +	 */
> +	mode = table->mode;
> +	if (root->set_ownership)
> +		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
>  	ei->sysctl = head;
>  	ei->sysctl_entry = table;
>  	hlist_add_head_rcu(&ei->sibling_inodes, &head->inodes);
> @@ -522,8 +533,8 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	spin_unlock(&sysctl_lock);
>  
>  	simple_inode_init_ts(inode);
> -	inode->i_mode = table->mode;
> -	if (!S_ISDIR(table->mode)) {
> +	inode->i_mode = mode;
> +	if (!S_ISDIR(mode)) {
>  		inode->i_mode |= S_IFREG;
>  		inode->i_op = &proc_sys_inode_operations;
>  		inode->i_fop = &proc_sys_file_operations;
> @@ -535,11 +546,6 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  			make_empty_dir_inode(inode);
>  	}
>  
> -	inode->i_uid = GLOBAL_ROOT_UID;
> -	inode->i_gid = GLOBAL_ROOT_GID;
> -	if (root->set_ownership)
> -		root->set_ownership(head, &inode->i_uid, &inode->i_gid);
> -
>  	return inode;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
