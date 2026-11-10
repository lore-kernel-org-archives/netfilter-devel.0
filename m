Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320486;
	b=qvsQ59ds9iF7DW+0iS3e30WvU1opNee4W3bwOPDJpsqWzpfpaVbxzefj5rEpkyrSU/vt
	 qafLNIZUu4rieZh5oFNBUNqDmcTta4xwyRAgE1aQ+B/tdPT0w5mhYTtyfXFeptiguOhYI
	 UpxcJgZAioj39E4Rx12ZJ/l4OeiwNUqSAVqeEcsN/Puc8/g59oKEBz2vh9qyCy3e64PJn
	 gdfEe2wH978Pn2W0F9stBTatjC8G1nOnkwu0rFqKe0lM1irbkiEgmrAYtlRtL1F4Xq5qv
	 XRqc434Jye6BbP0SF7Siu36yaC4+j3pNT2iN0h2TOYk94441ermxAMhdNsD2dPMMR+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320486;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Rspamd-Queue-Id:X-Spam-Level:X-Rspamd-Server:
	 X-Rspamd-Action:X-Spam-Flag:X-Spamd-Result:X-Spam-Score;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=ibMhozCS0TZx9aZRcfsw3D2umRHe/DUx5z1rMgYP8ycGhlR61yJIe2uIAQl/YURZJC6k
	 +zd7Lu4bBPIE7Mp+0ALnDLX5T06VlI2ejepA1YWfuop+n9NGq6lZcgtrhp1s1zTKj6FpS
	 f+2/KoE4HXnbq9Ccz+8LReTXmm8beQReUH41JrISk9P+fE2drmLRAKGCjfvLKfEnLdGGN
	 riFKaU8dxg9KWx/nLB1DtfT7fu6BzYbe+2BzArfjZzF7h79JH+svVEn/TBlkLnfS7VkNr
	 nX5xp6i752+Z/mZ0P/pHrh3E3djiRiMOXUXyySedLqQoQ6/dP4iPjAem5LhDK9Pc+dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dfqcbUnK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=I8IcNdZF;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lARv1EHw;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98996606A326;
	Tue, 10 Nov 2026 14:21:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98996606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=dfqcbUnK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=I8IcNdZF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lARv1EHw
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 98D081F769;
	Tue, 10 Nov 2026 14:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=dfqcbUnKWeMMrbbtQxI4HQM7qrIh4AZ0rdet9B/6ElOBIqFSiDGiuE+1U00ut3ACwyb91k
	r11g0ukmfmgZpAkPLIoBt7FBxKQ00ygdxuqdgmhj2u4V8/naZ4cHPSCZhNnU3P0rUj/quR
	5maXirFkXXk4Lg3EkYDJXPDsbTG0ICY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=I8IcNdZFZSFtUgRgMf53UkGbuTtSJb1zzUPCSb1BODWP/tylJEZx0BmLFYU3bDgA6b05ut
	5Oej5bk5j+xTBnDA==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OFZt5G3N;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lARv1EHw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794320481; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=OFZt5G3NjcxxJh9jY6RWrC7bvaHuyGavEEbdiAXuJUz/f1dYZmor5n2FYPrRYiQoiCED+w
	1FijM1hEbGwM1P7v2pYubJuTrAUHD24tVDcOF18S7gaHWryxvKiASS6IebdlsiiUolZCHc
	0QuxJjJxTEoiCmYYKfGjg6OEvasGjOc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794320481;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BAgS5IG5Q6cmw/IjXmlog3zuTwHd5kSy1jWUQMAUfKY=;
	b=lARv1EHwNdS7tCNwBSn9srQwOl9Kg5/ztnfBrMPMFrjJm7RNq+r333D6UmkiyHiKi5q76w
	+hVROod2CCZjqIBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 653AD13479;
	Tue, 10 Nov 2026 14:21:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id H5UxD2Eo82oxHAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 14:21:21 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id D4BBB22538; Tue, 10 Nov 2026 15:21:16 +0100 (CET)
Date: Tue, 10 Nov 2026 15:21:16 +0100
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
Subject: Re: [PATCH v2 07/51] lockd: don't hand out the terminator of
 nlm_end_grace
Message-ID: <4isxnxlzjedh4t3hq73g5wjuwdtiudxx6llf6do2noyrno5lsb@6xwb4gw7wi7b>
References: <20261104-work-procfs-bugfixes-v2-0-bbf7d5546809@kernel.org>
 <20261104-work-procfs-bugfixes-v2-7-bbf7d5546809@kernel.org>
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
In-Reply-To: <20261104-work-procfs-bugfixes-v2-7-bbf7d5546809@kernel.org>
X-Rspamd-Queue-Id: 98D081F769
X-Spam-Level: 
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,suse.cz:email,suse.com:email];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	TO_MATCH_ENVRCPT_SOME(0.00)[];
	RCPT_COUNT_GT_50(0.00)[59];
	RCVD_TLS_LAST(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	DKIM_TRACE(0.00)[suse.cz:+]
X-Spam-Score: -11.51

On Wed 04-11-26 18:27:24, Christian Brauner wrote:
> nlm_end_grace_read() answers with "Y\n" or "N\n" from a three byte
> buffer and hands out all three bytes, the terminating NUL included.
> Leave the NUL out.
> 
> Fixes: d68e3c4aa416 ("lockd: add a /proc/fs/lockd/nlm_end_grace file")
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Makes sense. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/lockd/procfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/lockd/procfs.c b/fs/lockd/procfs.c
> index a01f08c8c2f3..74f7ab77535a 100644
> --- a/fs/lockd/procfs.c
> +++ b/fs/lockd/procfs.c
> @@ -57,7 +57,7 @@ nlm_end_grace_read(struct file *file, char __user *buf, size_t size,
>  	resp[1] = '\n';
>  	resp[2] = '\0';
>  
> -	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp));
> +	return simple_read_from_buffer(buf, size, pos, resp, sizeof(resp) - 1);
>  }
>  
>  static const struct proc_ops lockd_end_grace_proc_ops = {
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
