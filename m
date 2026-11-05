Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793873634;
	b=anQGJWv+AjgeGVLvtocsxIs9gkMPQjIqMULudqPk+BQqpho70T+5C2J92NaK7opfMQLI
	 d3EESyR9SISoaylzUab1/wfpDZMkkwDK3Lrukm1R98z1abUJXJUSfllzkr1hvq4Kmue8k
	 aa/xTkdZ7fPVwLjQnBwOXyluDe78mm6l6XlTWra0lhmRctIMeRWV06Pr1iivAoYuKS0aQ
	 wwmKMVVujogZoq5P7G26eahkmfAjvZE7mKJ0Hur5rEQxhurU/Jqlkdxex+sSGwxTotjM1
	 t/rSjcsKdE0jSkpoPXITixd9vOIhvnH8WD6K8E+tOv+J6dGxjitvSCZKvCIaaR7kDng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793873634;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:
	 X-Forwarded-Encrypted:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
	b=exaRSlLOFOZ1PvvJkydey7g3x49RtdlOUDw2CwvUvFKFLC2IORadnSwWMv+HeneX3ilo
	 /26TPYa3kB7vjBuOG+YBN8B62ObsINzifZzgPJ5/C+mY7C3WQFNX9tGiR8B41mROvrMp6
	 E8dP6VjwBYeglH+UqzXUyO8mOQbXKaeAGwVv+5dei6NesaBXe8NZi/fhnrASgn5Qzt98g
	 sC76dcfK2J5tzvUWqE9Uu6exeBAqd3r0SH5hVXZsKdFoxq/r0EBJ783vx6fnMgeUDM3nh
	 YWR73wAR+1WAf/2QHh3GC3wwcKlUYEMaIiSBIPfdqWPN9nuwFsI/VGmIM+71MyEaPag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-m68k.org;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F95606A335
	for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2026 10:13:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 68F95606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5430f70c827so17750851cf.2
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 02:13:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793873633; x=1794478433;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HRfPjQi/EPajP85bp44Mrjs4W2fVG4O74jaEjdHYdtc=;
        b=0iJiWLCrmW27FiZbopAX6LHMYOjO+7XyVpDHs4Y1hPXq6Y1VEdP/aWFSc2Eu+nrPs0
         RmynKIcinXOaUKYEnUo60N/d0YKDdzAfx7zyTve5sZyoowfNnaFgTgvqrXIuUzGiMgZO
         l1jmfS33kXTDLoTiaJXqvCSb32QYEuLoZgEk4XayfBdyh+/1HmQeQ2AImhaEYiCVyQMv
         H8RQKVNzVGrdOR9M33SvPY7ZG28dGPxyqVuwUKW0XDA58zZUsTd0QB1mORJEC+RTtgk2
         iSVCdgKIX69egto9Flz+MdF8GtfGAoSeWGK4fpq10sKjcWtS+sxXezjdAdxwiUaQUx/G
         545Q==
X-Forwarded-Encrypted: i=1; AKwUvBwSCLZmzdz/k2mYCAID/V2XyOKutqVgYnkHtxzPNwWbciQeemF/JShiFelmrBX1jJbx5kbSDNvZXTrMkk0aEG4=@vger.kernel.org
X-Gm-Message-State: APuU4Z/nVA0iXpHsX5vSIOUM/hzMBIRdliLwQy55zWZd+HTtSB8duCH+
	wp59eNm/brE4E4Vfo5aiJjoc2FpWl4uf7jXuH2wkP6b4GHRSRDswp6c7n9FqTYiQ+3A=
X-Gm-Gg: AYBFou2BAVNn2biFOJyb8HQzsiWZtTwo4wKLLPbVjBjMzqlHeTciXJu6ojQcGOJQM5g
	vfaQR/szX0IKLaOiR2gNj/El0ccqgWSwzVsqVY2iGZtRKfVHkqYSkcD7dKW8RXtdjU97+mCjBHc
	LfyAKzzITWZILIcChcRoIqxIJ0PPIa8k3qegqx+iqNYFUanfv9KZF2elRplUT2Ca4901jZsr12H
	AmyVFDsO6BagcjyiQSu1XEpN2LGHzQft2WY7sWYULfKHvvZOCkg2KD9SHSOVS5yYRfLotMKT8ak
	kIUvw1aWswCq0VZZEK31wilUdbUC96tdUGD+YjSjhBFjIqGynmuQ3mVAfbBNqpWFrDum2OGDKZT
	7DiSjb6rv4rEwAWu1KHoKTLVfAfNb0qsSLyi0qT/KOua1ZfJc88sb6ZMJRcjV3fNr0IyGUUehi/
	ndbrIPikNxxkvmVst/heejm04SveTsygPR4qNmpG9VBrRS6x6JD611QPab93tFLWoxGEzOujGM6
	JZO3EfYd3KZDSRVskBhu156Jey4GBoq4Bq1mW3kIsuylhSwxuE40Yf40u3ZYJ/FkJ+18XEEeDhD
	0tar/U9KXicgbttEzV7RqLJ0BWmQlPiBDRxQrst9tNG1rJ6ECE1xIjJ3Omo3gWMu7A==
X-Received: by 2002:a05:622a:1b03:b0:532:abc9:8f4f with SMTP id d75a77b69052e-542b71458f4mr327755761cf.37.1793873633335;
        Thu, 05 Nov 2026 02:13:53 -0800 (PST)
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com. [209.85.219.46])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-54b10cd8ea0sm47063911cf.27.2026.11.05.02.13.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 02:13:52 -0800 (PST)
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c162febb9so16903376d6.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2026 02:13:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByONRRLlT73z+brEQEm6VYRaIEDh4T6igkqDS7TIOg+x8Wi9FSxotp6bCZpAlGm3/5sbyMaGfHUg74XjsMI2bc=@vger.kernel.org
X-Received: by 2002:a05:6102:374c:b0:7cc:1a41:20e8 with SMTP id
 ada2fe7eead31-7d07227a940mr8060714137.5.1793873263361; Thu, 05 Nov 2026
 02:07:43 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-core-v2-0-76ace653a773@kernel.org> <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
In-Reply-To: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 5 Nov 2026 11:07:32 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
X-Gm-Features: AclHuK9naqg5CZQ7lhJVrMhg9TNH44f-SpA5WbUGCGBsAlcoOw2midTd7doJSmk
Message-ID: <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Jann Horn <jannh@google.com>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Mason <mason@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman <gregkh@suse.de>, 
	Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, Jan Kara <jack@suse.cz>, 
	Jan Kara <jack@suse.com>, linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, ntfs3@lists.linux.dev, 
	platform-driver-x86@vger.kernel.org, coreteam@netfilter.org, 
	kexec@lists.infradead.org, linux-pci@vger.kernel.org, 
	linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net, 
	jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org, 
	linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org, 
	linux-sh@vger.kernel.org, linux-usb@vger.kernel.org, 
	samba-technical@lists.samba.org, sparclinux@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net, 
	Takashi Iwai <tiwai@suse.de>, linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
	linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Christian,

On Wed, 4 Nov 2026 at 20:32, Christian Brauner <brauner@kernel.org> wrote:
> proc_reg_write() pins the entry and calls ->proc_write() which copies
> from userspace itself. A page fault in that copy can take as long as
> the writer wants, just like the copy to userspace of a read, and
> remove_proc_entry() waits for it.
>
> So do what kernfs does for writes as well. An entry that implements
> ->proc_write_buf() gets a NUL-terminated kernel copy of what was
> written. procfs makes that copy before it pins the entry. The copy is
> capped at ->proc_write_size bytes, or at PAGE_SIZE - 1 like
> proc_simple_write() if the entry doesn't care. Larger writes fail with
> -EINVAL. The proc_ops go away with the entry, so procfs remembers the
> limit in the entry when it is registered, like the size of the seq_file
> state, instead of pinning the entry just to look up a number.
>
> Entries that take binary data in pieces, like the PCI config space,
> ALSA's data entries or a firmware image, can ask for
> PROC_ENTRY_SHORT_WRITES instead. procfs then copies in the first
> ->proc_write_size bytes and the write comes up short.
>
> ->proc_write_buf() gets the position like ->proc_write() so entries
> that write at an offset keep working.
>
> Note that procfs copies in the whole write before the entry looks at any
> of it. So a write that is too large or whose buffer can't be read fails
> before the entry's own checks run, permission checks included, even
> where the entry only ever looked at the first few bytes.
>
> An entry that implements ->proc_write_buf() and still has a
> ->proc_write() fails to register.
>
> No users yet.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks for your patch!

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -67,6 +74,16 @@ struct proc_ops {
>         const struct seq_operations *proc_seq_ops;
>         int     (*proc_show)(struct seq_file *, void *);
>         unsigned int proc_state_size;
> +       /*
> +        * procfs copies what is written into a kernel buffer and calls
> +        * ->proc_write_buf() with it. The buffer is NUL-terminated and holds
> +        * at most ->proc_write_size bytes, PAGE_SIZE - 1 if that's 0. Larger
> +        * writes fail with -EINVAL unless the entry asks for
> +        * PROC_ENTRY_SHORT_WRITES. The position is NULL for a stream, like
> +        * for ->write().
> +        */
> +       ssize_t (*proc_write_buf)(struct file *, char *, size_t, loff_t *);

"const char *"?

Seems like you have to drop several const attributes during the
conversion from "const char __user *buf" to "char *buf".

While at it, I think it would be good to use this conversion as an
opportunity to replace "char *" by "void *", which will probably let
you drop several casts from users.

> +       unsigned int proc_write_size;
>  } __randomize_layout;
>
>  /* definitions for hide_pid field */
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
