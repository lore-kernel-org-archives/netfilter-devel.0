Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320707;
	b=kjj3BKyoc/aMaqltkJfJvlsNiRXnWfGIF3+3d9nzavAuAKbS1S00X1K+gJkG44a+7twk
	 rkxt2LdaalyEPoiwUIAQWB8GYn2v7Y/Pyk5N67SsX2uXaZLafjEueX2rGvPlt6wBfW53p
	 W+Awooj1KUN3yM09XDrxQ25+dIsKOZVc8q5rplLKZHQ/Mo7teRyKba/e6SKjOQxPJURfk
	 t7+reGsVO7hy3qZY/N3VKS8nJw3D3SVqqudcMDzMuooItwdzz8P9QppijQWVAaRd+35eE
	 ePAmk8Sbu2lJtIha7qUvsU42FYCfUF6ZepHvoR/y7wFGsxJpbkp7Zs5yi4KvVN/dLDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320707;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=VwLu3FYQCXShCI2QopXAa92PRxMBfnEnLeqVHCweNdegRxnjq6fKXO56LmarQjenF0oG
	 +mIUiIBbGwRVRqwnWyz9DR7D/XOvtF9YXYPTVZH282ikmdMFhyMG2f3WoDQjxy8zQxUwy
	 OEGHTlyTldXK80PQaKzQQ99i1BRutvY3yPwotN7DxJHUHRNW8ZSD/+gjScNlhE8LI2Snb
	 d93ouBAr2AuhaeljfKPtW+7gisvnaZdc0J3Sw4mxDVgyrofVYuAKORbfEKWsgXve6Vuby
	 5g0NhRZkkKDVrOjvsZBa6CXVtExzgvifcAsa+nsZI4BoxUeRb+rzzxVvD/IEUUfCPBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844CC60A261A;
	Tue, 10 Nov 2026 14:25:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 844CC60A261A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DcZW88hG
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CCDD21F7DA;
	Tue, 10 Nov 2026 14:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=bjk4WUGsRYs0sP8E0ONkDW8hyxwCcqK6F/Z+No2aVyfis1MlyWmiOhtWAdfYs7F/8CipUe
	M6ChAxycGmD+5TO2yaDPV3YEJYRhQ7n9jG4KZpA9RGENMEDcySYwTh7Zpl9Q1XnchbyaQz
	9csObL3BU5hnSJHNTzbwr+PQnEnCSJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=DcZW88hGUmkolX453pml7rhjUnXP/geJBXTnLO3CcrhsdfC+rAH/ij69WBdSoxJA/XOD03
	2vl1fFNAf7DiXYCQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bjk4WUGs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DcZW88hG
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=bjk4WUGsRYs0sP8E0ONkDW8hyxwCcqK6F/Z+No2aVyfis1MlyWmiOhtWAdfYs7F/8CipUe
	M6ChAxycGmD+5TO2yaDPV3YEJYRhQ7n9jG4KZpA9RGENMEDcySYwTh7Zpl9Q1XnchbyaQz
	9csObL3BU5hnSJHNTzbwr+PQnEnCSJ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vFU8SLB5yQFXTKmgyVP3p6vbPpLP3uckbwzKSwj5Zbg=;
	b=DcZW88hGUmkolX453pml7rhjUnXP/geJBXTnLO3CcrhsdfC+rAH/ij69WBdSoxJA/XOD03
	2vl1fFNAf7DiXYCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A1740134F4;
	Tue, 10 Nov 2026 14:25:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bTl7H0Ap82qbIAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:25:04 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A39EC2253A; Tue, 10 Nov 2026 15:24:59 +0100 (CET)
Date: Tue, 10 Nov 2026 15:24:59 +0100
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
Subject: Re: [PATCH v2 14/51] proc: sysctl: don't stop readdir at an entry
 that is being unregistered
Message-ID: <efix7fc3j7xbogyb3zaotsi3bwl4s4p6nvwrnlpbue5khrlf43@orqtyoglh5b7>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-14-bbf7d5546809@kernel.org>
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-14-bbf7d5546809@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.cz:dkim];
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
X-Rspamd-Queue-Id: CCDD21F7DA

On Wed 04-11-26 18:47:00, Christian Brauner wrote:
> proc_sys_fill_cache() creates the inode of an entry that has no dentry
> yet. Since ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under
> sysctl_lock.") proc_sys_make_inode() refuses to do that once the table
> is being unregistered and fails with -ENOENT. readdir takes every table
> it lists into use and unregister_sysctl_table() marks the table as
> being unregistered before it waits for readdir to let go of it. So an
> entry that is unregistered right then makes proc_sys_fill_cache() fail,
> proc_sys_readdir() stops there and returns 0. If that getdents64() call
> hadn't emitted anything before that entry userspace sees the end of the
> directory and never gets the entries behind it. A listing of
> /proc/sys/net/ipv6/conf can end early that way while a device goes
> away.
> 
> So skip an entry whose table is being unregistered, like readdir
> already skips a link it can't follow. Lookup treats such an entry as
> gone too since ea5751ccd665 ("proc/sysctl: don't return ENOMEM on
> lookup when a table is unregistering").
> 
> Fixes: ace0c791e6c3 ("proc/sysctl: Don't grab i_lock under sysctl_lock.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks sane. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/proc/proc_sysctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 6c0859c66563..b4a309d49698 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -704,6 +704,9 @@ static bool proc_sys_fill_cache(struct file *file,
>  			if (unlikely(res)) {
>  				dput(child);
>  
> +				/* skip an entry whose table is being unregistered */
> +				if (res == ERR_PTR(-ENOENT))
> +					return true;
>  				if (IS_ERR(res))
>  					return false;
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
