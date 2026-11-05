Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793882195;
	b=HPAXYnVjVrRIAAAhkOA+dNuijL6VszJ9VBmwLymdaxatICUBU/U74bGPbooQg0iEjQjT
	 pMAQwndP6BTvXnMr1wbXtumftJ8x2TFew/SOZaf69aIsV3jkBLVrsmNBeyEVI/nYI4jKp
	 a8vEWTiLKcmc3KRDYNoWOHtK2Elhmu9MxfWEo86NoqhkYk/iHUQfu/EwgS67zEJKE/we7
	 DCfHEJh7BNaZte6aj8pQRIq0Q7qrsKFQpvxD/6u44kNYRZOSK2Jz6sdjGWhVueRO6iYR8
	 tetfQXOghAW/wyD5mxg+iQmPTAJpxm5h/q/Q4Qhjw8++fwg8BDOfUUS492aZ77Thezg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793882195;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=hBIqKO0nxA/MHaWcy76mBtJVLSG9rU1eaoReUnnbjhvPpepYWUyNnYQcg4jX41elhmt/
	 SPtzqh32yj6kwhnAOGL373vTwpUPKcQNoznB4MR/nTrDa24YiKNEBlM6KxwSSN9ZL6UaB
	 n18uRbaGGoqpby6b9Yaiy8f8Gwnkj2OEaFrqawagBayN2JeYhgf31/bXfsQDYpml50pJG
	 ews98QY6kIlrtQkI3uG0A5iws7iFpjK+DUCLVMGmDxhoFdOdRAv18Qa0qVz107eJN/xQz
	 2Y25e4sEFALy+4+LOIMDNXuC3gdp44F16Jo/Ha1qYCHROCI+XDCYXwi2x5owSTD5bqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JZx76L+g;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b="8/5XD6W9";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T3Jse+8w;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BYgAZw+U;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14231606A326;
	Thu,  5 Nov 2026 12:36:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14231606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=JZx76L+g;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8/5XD6W9;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T3Jse+8w;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BYgAZw+U
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6EE151F785;
	Thu,  5 Nov 2026 12:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793882193; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=JZx76L+ggOq++v50JrM+txlftOOqxJaKF/tK8uhPwld5Q9GnNQfLXM1whyLb1DsMeHXH/C
	/uTr5WEx4MoDADem0Lt2IRl8UnJCEvNjej74YyT5VZBSM782Vk2aNTEZTgyxnuBLnPZ/fS
	Mhf/U17g3frl5lC6gN/6C/6ftmbFF2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793882193;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=8/5XD6W9JBZBD7IT0Gng8T7errG+mfSR55zIjyH58gQPHLQ3a+6mBXLPeQK6OumZ9O/ASJ
	a0+wPfZoC8vZgnDQ==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793882192; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=T3Jse+8wWvU2m0agalLdcO3u4gc4aSPygpqteqhLhNd/aBjFrhyiDCC1i0Lv+iYh3z1s6e
	fnA2+Jf6Yg0jKvkbvYGo3ERh6eFq09U2ijwb8SlUT+DSbyddzL3tu06qm3Tz++uFh8zr+9
	+TrYzUca/b6bladItMQ0Kk0+pK0H3fw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793882192;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DpjKnWhAHhajlU0N8yPm40hOORTtvriSHlYmNC33ga8=;
	b=BYgAZw+Ujm4L/dnuxqWK1yrVNISlV/1cL+J702exe7XcXF17FVJLhwkbWz39x0ZpRyHhhI
	iDaH9TFqNTx9SSCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1DBD9134F6;
	Thu,  5 Nov 2026 12:36:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AxmaAFB47Go4MAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 05 Nov 2026 12:36:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 9532FB6E6; Thu, 05 Nov 2026 13:36:31 +0100 (CET)
Date: Thu, 5 Nov 2026 13:36:31 +0100
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
Subject: Re: [PATCH RFC 37/38] proc: don't pin a symlink's entry while
 readlink() copies it out
Message-ID: <krgvwwpug6brspfpubssohr6cknwd2wtkrxo6uqaoalfi2ay4v@3dtbsctwca3n>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
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
In-Reply-To: <20261102-work-procfs-bugfixes-v1-37-59422ed3e465@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.com:email,suse.cz:email]
X-Spam-Score: -11.30

On Mon 02-11-26 15:43:28, Christian Brauner wrote:
> proc_get_link() pins the entry with use_pde() and the delayed call
> unpins it. vfs_readlink() copies the link to userspace in between. So a
> page fault in that copy holds up remove_proc_entry() just like the
> copies of reads and writes do, and the callers hold locks while they
> wait. /proc/asound/<id> is removed with snd_card_mutex and info_mutex
> held when a card changes its id.
> 
> The pin doesn't keep anything alive. proc_symlink() copies the target
> and pde_free() frees it with the entry, and the inode holds a reference
> to the entry. What the pin does is keep a removed symlink from being
> followed. So check ->in_use instead and drop the delayed call. That
> also takes an atomic pair off every traversal of /proc/net and
> /proc/mounts.
> 
> Fixes: 7e0e953bb0cf ("procfs: fix race between symlink removals and traversals")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/inode.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/proc/inode.c b/fs/proc/inode.c
> index 9933f03ab9fb..2d65f3c8ec03 100644
> --- a/fs/proc/inode.c
> +++ b/fs/proc/inode.c
> @@ -629,19 +629,19 @@ static const struct file_operations proc_iter_file_ops_compat = {
>  };
>  #endif
>  
> -static void proc_put_link(void *p)
> -{
> -	unuse_pde(p);
> -}
> -
>  static const char *proc_get_link(struct dentry *dentry,
>  				 struct inode *inode,
>  				 struct delayed_call *done)
>  {
>  	struct proc_dir_entry *pde = PDE(inode);
> -	if (!use_pde(pde))
> +
> +	/*
> +	 * No pin. The link lives with the entry, which the inode holds, and a
> +	 * reader could fault while vfs_readlink() copies it out. Just don't
> +	 * follow a removed one.
> +	 */
> +	if (unlikely(atomic_read(&pde->in_use) < 0))
>  		return ERR_PTR(-EINVAL);
> -	set_delayed_call(done, proc_put_link, pde);
>  	return pde->data;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
