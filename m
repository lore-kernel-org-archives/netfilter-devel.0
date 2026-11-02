Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632354;
	b=oQ4xlLqO053MDjdFvvLRPWBkXL0JAaSdzRBJ+1S00CvjDIm57oW2EVEZtV1Tx7Ck7TzL
	 Dh0KEvTcy7FK3PKbcWO1NoNXF6Bj/PHzuCfA8gDpc27MP2OjEKN8g+Tq8gARTVhA0QlOM
	 RR8I4Swj9GswN/e43knXYkh6hHocdSsGFm+H5UUK+WyGS75MXyvxjDQAVLLCPb0lloDF7
	 sFYFod9X5FreFbVkczAJGdty6fD6VV93ofITpGlmS1aoIONZiLtRz50BGmy3vnUwYnXlP
	 igTvntGKWZFJI08dHnEY1qA3PPcX+EQot5zL4z4zF++TRJKJN/Q/lxjYXr1tiNutapw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632354;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=2puUSp7/76IVMJdmyNoOx/+sDBWWUsstBNYgnLqWADw=;
	b=nRIwIA9WSuEdP6Z6JPI4eThvftuO71nUgOhz/ky6CKsNzHcx2iBBGfbpT6toZZbrtj2z
	 VOK6+q92QtOKk/i6qN4LhXtsZCIzaZOTb87tjtzsLb11QXN150nxpNv3Ne67BCa+63+ab
	 xs/YsCB6e6mZBVF874TzkcgqHnWjfHxjgpTVFqxo5b/xX97WrYYVs6ykQ6zMw8moyh+So
	 pDLm0zsqXMrnpXN8WxXQTJnDR2UHRxrwzrdd6lZ9i6Lhs5Rmqcij/PNMAhDJIt4EGrsmB
	 622K6szDebDVxyW24cUQ0YXpVRh/VzlV2iiP2PVD7QO53jqIa84wA7OeqzLbe4GUwJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="Sfo/4AT7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42AD606D81A
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Sfo/4AT7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF161F00A17
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Nov 2026 15:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632353;
	bh=2puUSp7/76IVMJdmyNoOx/+sDBWWUsstBNYgnLqWADw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=Sfo/4AT7eUqvUQF2IM0e4yUEA2S9bpSgz1XRSpjXSv6ivoD7gSmdHg3A8zkMAzcYF
	 kDeGVWk3w/Tf8dF2CaaqoDKojou4fpxW/on8Svaj+X1DsQ+lK5Z5lhob5+JYVA7rw6
	 hITFfUucA9qYfQ8dPtI4POqoUKejJwAfyqbxGiCXRDyz5vtCphvlDDhACUZcWSe4n/
	 ZVHvC1IZ3kRo3yXPQWrol3dLHlfbECyrsb8CqMIBuOtjWNn600zPylndtXWynXYehg
	 5byT636d5OG32RU0HlJaXhW8fAU3PP9qmYjTFfxdvhBHu58rPWCtlcB3lPJonv+QGn
	 dVYMBTLl9OINw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 64F40F40068;
	Mon,  2 Nov 2026 10:12:32 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:12:32 -0500
X-ME-Sender: <xms:YKjoaq8wAwd1IxUiNYUpg-bkAIevhoVV9sHdGLHZFj4QUhhzr1x5dQ>
    <xme:YKjoaljI-1gGkFxaVyg_RqXwj5e_0QeGd2rUXEBcY1YCCDDrc86cgxF5xbiC-_Cyk
    eeUYesQG6CNyMpPZfeTzNarIloBQGkO5keAuTJbX4C1LvGugkip7jU>
X-ME-Proxy-Cause: dmFkZTEpafQGZH1RQHraPbR3WHAFR05zdMzeN9033f2qTgB7dcFqSOfXqTOx0NsnLhw7RM
    t4KdFk7naEvVgIj/Z+/r4wqxKPOiZvigH11WmNrz/u7/O6i5K5shWdxKaODLIvcArDmp5/
    qndNFVKeXJ3sh1NXWVNTKi/f4Rew9h2JP1HN5dSGNPeCJYu7x5a3H8LsoXn8EhN4ZjsAvm
    /bED5Y0vKx7GQlt/0hSGrTZnAD9OLn1kAybK9sGzqh2Zq0UvMp2FTqaVuKBk/gi41sjl26
    /rIVYFwvydSbfMatEx+7lJ8J3VmRw3IeLBLJbi9GYEeXDptwe8H5zILOCv2qRxqKoQzcX7
    hPgLViYfGwx2iwsPEJoWchmJ3TIop7fYjZ48Bx7ibXnIoxjvHdBXfdG6wFKlG348EI2Q1w
    vauIP56PdA/Ls5ERDf3LXyHFvGGr5GZavecratgQSsWiI1fIs/OBdCe543F+RoU/DRx88u
    Y4xY0Yz432+umY+PGsUQvKduBltnzUzHdH9p7mNKs9B+1aRWZ9sTlNN3wFPqdtlFNpQD0J
    AspjcLf4x4Y1ZTk+Hmj8GytvXphaLBgSYqvkHiS/BgYavnqOy/Od3KhxXOSyjKUEBNKhxX
    gIbVdFtmJzsdMKMnsFVsGZx0rWNsYIOjwaZTVGysGXYo8LNPGECoq0wD+gKw
X-ME-Proxy: <xmx:YKjoaoiFH3KJWJxPJNP6RgVDRJnRZqabHPC0TlSatlT1AbgfNmmgtQ>
    <xmx:YKjoailIciWpQqUXZJnA3LXb1URirrNW2DnWgTxtKfYfpyae1_HZdg>
    <xmx:YKjoavUl1PiISqAcnsiY1t8zKyiZTJkZa9xV9NCA_Qs5qfyjBbkdNQ>
    <xmx:YKjoavsYSSsfdxcsdgd_dZkXzpdAhtBFmmKV6oj9EC0Hyomvq5YQ7w>
    <xmx:YKjoaq4yjpW-RjcSpdiQDCrjtodwfPysFTH0NY0ctqy0rG92WwlUU8GY>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 42C93782738; Mon,  2 Nov 2026 10:12:32 -0500 (EST)
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
X-ThreadId: ARCrrC6bRUOw
Date: Mon, 02 Nov 2026 10:12:12 -0500
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
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org,
 stable@vger.kernel.org
Message-Id: <16f91f93-16b4-49b1-b7fa-cec69759c349@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-27-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
 <20261102-work-procfs-bugfixes-v1-27-59422ed3e465@kernel.org>
Subject: Re: [PATCH RFC 27/38] sunrpc: make queue_wait a global wait queue again
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 9:21 AM, Christian Brauner wrote:
> Since commit 552d0e17ea04 ("sunrpc: convert queue_wait from global to
> per-cache-detail waitqueue") poll() and epoll queue their waiters for a
> channel file on the queue_wait head in struct cache_detail. But the
> cache_detail can be freed while its channel file is still open and
> waited on.
>
> The procfs channel files of a network namespace are removed when the
> namespace goes away. Removing a procfs file waits for the callers that
> are in one of its methods right now and then calls ->release on every
> file that is still open (cf. close_pdeo()). The waiters that poll() and
> epoll left on the head stay queued until their file is really closed.
> So:
>
>   sunrpc_exit_net()
>   -> ip_map_cache_destroy()
>      -> cache_unregister_net()
>         -> remove_cache_proc_entries()
>            -> proc_remove()      // ->release, the waiters stay queued
>      -> cache_destroy_net()      // kfree(cd)
>
> and when poll() returns remove_wait_queue() writes to the freed
> cache_detail:
>
>   BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x4b/0xa0
>   Read of size 1 at addr ff110001131bb570 by task sunrpc-poll-uaf/242
>   Call Trace:
>    remove_wait_queue+0x22/0x1c0
>    poll_freewait+0xc2/0x230
>    do_sys_poll+0x9ba/0xd50
>    __x64_sys_poll+0x165/0x470
>   Freed by task 12:
>    kfree+0x267/0x620
>    sunrpc_exit_net+0x34/0x80
>    ops_undo_list+0x271/0x8d0
>    cleanup_net+0x3f3/0x860
>
> Closing an epoll instance that watches the file gets there through
> ep_unregister_pollwait() instead.
>
> The channel files of a network namespace belong to the root of its
> user namespace and cache_open() doesn't check for a capability. So an
> unprivileged user can open the channel file of a namespace of its own
> from the outside, poll it and let the namespace die.
>
> Go back to a single static wait queue that never goes away. A wakeup
> for one cache wakes the waiters of all caches again but cache_poll()
> reports per cache_detail so that's just a spurious wakeup. procfs
> should really own the wait queue of its files like kernfs does but
> that's nothing for stable.
>
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 552d0e17ea04 ("sunrpc: convert queue_wait from global to 
> per-cache-detail waitqueue")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
