Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793823133;
	b=Kw3CgWt+i4o+ONErhlF/YTDMgn/ddF0yyMcJYVxSAN8fBrXeRkWzIMxxgkQzieH2bTAe
	 RKbuz5bx9J0Jqbtdpf37hPQzL/S/77IwylYQe30q602T0Sk+UGOff7MIwP0T0wbr1+SWD
	 nPY+n6mtJiCDYUu8SxDfZrdcFYra0DUjntayMtiNXULO5tO1fihUTDJNze/xff+5m2nr1
	 bV04NynGTul/DE0itmbWo5Gwu05sNKg/VDJ9vJrKANIP2BewF9LjMWvEqlCLYsNoGcEqT
	 x/0YEuJPasPPH+hBuWNY5j6xBhdcBLU037Oo8Wxhx15GHo3K5jTc3DaN4WV4OoCu6DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793823133;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:X-Forwarded-Encrypted:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
	b=fRLvlJrTkaF4WQIBVGIqVBkovRG4fXpJ1ICcPEFpyFS1uBRVqeGL3rOQqO7YQ66PaW5j
	 rOSXa8igf/+XwfXGgOqp2+MjcqbGXOmJnEEpXbohG1bDza2eFcklGBdKbTJKwlscZcuhH
	 +ghTUTnmFs+E+8IrWKslPGxXLTK3vqJaf4XoPrkBR2rkgzUNI8OChCo8HUA9qSVfLdji2
	 jOv0IJ627d65rIqBOxbqfFerFGZOxek2BesC49WmUTzC0RNe2Zu3yTzFiE1tzNIkfZdun
	 Krgbd7CDpFcB1P2rpgklv52x3i6lNA3r0rX2tfjihydZsip/gkrRBFpnyRUWjQhSUKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=linux-foundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=IzCCgcHN;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51666080782
	for <netfilter-devel@vger.kernel.org>; Wed,  4 Nov 2026 20:12:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E51666080782
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=IzCCgcHN
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4550d8ab15so176932366b.2
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Nov 2026 12:12:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1793823131; x=1794427931; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=IzCCgcHNOb90cC+5Q+ouCET2Ny/4OiV7kgTbqK9AwEzkljILe+XDlcUbDFGh8BPDe+
         7DVkvl6I5YUFCiMEdEVe6c/azmspFcH1SeG4bgZWXvdkJA9vLnXvq7u3Ev4AZ3VL0QTx
         O1eeIB6aKuVi570PnFB99wRsvvZFGcbpvON0Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793823131; x=1794427931;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LCqiLHf1DIbfKNXx3ccWkvqxBhOdwo3yYkazQxIGarg=;
        b=HRZf3eZEJL2S0lsWOY5wzjskUYOIY7kjEkaKfkCG1j85ZfiKZ6eJ4w0UzGZAsQuI1f
         yjYlIny2SS9pV/HTuIRW6VR9wtAGuG535f/5vC6mt82HdJizP/GnTPPLq5w+gn84/F41
         6q7pHWHeB+g7RQvRd1EnrUpcFi58ZddIhVIoet5U0qLXzkBSNmCR33w4TQ34lGjYviAI
         SbdtxlM1PcH4IvYIfVHGmqmcJFehgo06TCaNawKkBWlbgL0qpa4Ixht4Aj5f1rLAVERd
         XApFlNWakWAwc2RBEdkwJeWgQhSacE5Caz1oe6E7CllUOVHPdPWuPzdEKAnSsOKT24qi
         JAwA==
X-Forwarded-Encrypted: i=1; AKwUvBwXO227pJfRMN1L3TzvK8oFZOyh8Rag36e3hPoAyQuaWmtU/RgO+6rixidaIWuY7jRJd+ZWAZ2lryiM9BReE7o=@vger.kernel.org
X-Gm-Message-State: APuU4Z/3OCsQZDKDa7i065U+yR6FxjS9zMsoEBHHVVxYxvXsWIE+qJkt
	D7ZhwsobelNvRX6XL3paXCX91cJRJ4lWlsSxZPRLC9aEP11G5c4bP1uc2st2xpKPn7T94EwgTps
	RsJqJ9v2OrQ==
X-Gm-Gg: AYBFou0NylNx3EyYmPaQc1nyVEqnOXqNPrfq5X88lb3i/72aoXOGgHTd+ru3ad3hAAP
	7aXB4TDMX7fRmeuk2pLAf1heiOT/EcvC1yv3nTxninZprkKXXx7igIrSMKyYudR4n9rHk8k0shz
	q5eMRV+ofjlulmd4CTft41fr5q2l3y9s5SdsTSe9EYRefHa24HmKHkeXKOzzMJwHf7o1ssYN+Rw
	c//C650AFHH/MZdkm5jSdNWH/DpqfwQ8AQWc1n2XM4gzIe82yyzADYRNWWPQ4xtqEpi7CH06BgZ
	FlnUMqtRQYvu7iXZ7ZfCzcUXbiuTN7ULJQExms/ufxApsNGXfkn1e/YskTEgwfiVRKd3J+MzKvs
	p4p49cqoN1qPeyQs1tQyU+0pzSQLyx5m4apvRDWF5lLPGPHDw2EYQpJoHDRbjrUyBI/nGiOz8se
	Qa1XbiEVoYV0LejxJeHgnxNpL6Cbr4xuU1bP2xbyhVSYcOgCeBR7L+CnCNEfq8OfFNSNspwDVDv
	ia7zMv45fG+IqVoRtplbQqFXA1JZzEpeJNNxjQ+9DcM2OpFTNmfex6V/SFF+lBAwsrlQMDiCnk4
	n0sp0uzLrNk7bYfn7lXXqYBedCjZ3U5yzDiFkdNL98hBPTpwhL0Cljdn4mdE29/+1vnt8YXwcjj
	JdQ==
X-Received: by 2002:a17:907:9341:b0:c49:cf38:3baf with SMTP id a640c23a62f3a-c4ca795d38emr1524293166b.5.1793823131313;
        Wed, 04 Nov 2026 12:12:11 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e48b93dsm105384866b.64.2026.11.04.12.12.11
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 12:12:11 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b579003f29so82246a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Nov 2026 12:12:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzqgTM2h+5Ix4DMhTy1MyqbAQukYcMiD+kjWY90gwy+pKmym9M8hsluARo5ygI9SkWGTOvc1pzd+cwYDTGsF+Y=@vger.kernel.org
X-Received: by 2002:a17:907:60c8:b0:c49:a4b1:9cb1 with SMTP id
 a640c23a62f3a-c4ca795fa50mr1973235866b.3.1793822725121; Wed, 04 Nov 2026
 12:05:25 -0800 (PST)
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner> <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Nov 2026 12:05:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
X-Gm-Features: AclHuK9j_YIgrwhhpWOlnull6heAULBd4dgTqoOhUQQjFm_MgoIgrL1vgPfefvI
Message-ID: <CAHk-=wj9Y9NcOesBBm+jhPjYa7qO00fD7g7uwX+H-k0-R2difA@mail.gmail.com>
Subject: Re: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm
 entries (Part 5/7)
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
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

On Wed, 4 Nov 2026 at 11:49, Christian Brauner <brauner@kernel.org> wrote:
>
> Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2

Christian - way too many patches, re-sent much too often, cc'd to way
too many people.

Nobody is going to read these repeated resends, and all you are doing
is clogging up peoples mailboxes.

             Linus
