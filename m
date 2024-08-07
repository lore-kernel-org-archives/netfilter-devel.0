Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD19179DC7
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 16:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723047734; cv=none; b=iQSfg3kHcb6yFrka6/4a7bNLa5+Onm8hLTR+KpbvIeclE302SiUhx7jFNQtLGB7JjFxj7IU3yjAfyXZZ9GguD+ctBt4qcFLfZj3x/E739XLY+8oNa5cfRpW3DRnGs8HHMV0CP4Qfcuk9uTExc9l9tjR9CaIVeuoXzehEnDw2U1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723047734; c=relaxed/simple;
	bh=PXd6Yn8JQCDJkdiX+USYauTMdLxGgDK5qLUUPZe+8DM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPnaOnhnbUZFgrvjvYh1IvkfcGr7yVlM+kMTx2ucugho0dRjrpdIAoWlc5XBD6hriKM9uFdmTbX2C1TZWrNNbvbtln71MtTSALEjZgiHM3H5xbiM9DadbUanKovHfYSAD11lTaCRbOmsDL4rJaT0KHDbNCDmiBjTvhvpXq6ozl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sbjQJ-0006BM-3Z; Wed, 07 Aug 2024 18:22:03 +0200
Date: Wed, 7 Aug 2024 18:22:03 +0200
From: Florian Westphal <fw@strlen.de>
To: josh lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: compiling with kernel headers
Message-ID: <20240807162203.GA22962@breakpoint.cc>
References: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

josh lant <joshualant@googlemail.com> wrote:
> I am trying to build for the Morello architecture, which uses
> hardware-based capabilities for memory safety, effectively extending
> pointer size to 128b, with 64b address and then added bounds/type
> information etc in the upper 64b.
> 
> Because of this I have had to modify a number of the kernel uapi
> headers. If you would like some more context of why I am having to do
> this, please see the discussion in this thread:
> 
> https://op-lists.linaro.org/archives/list/linux-morello@op-lists.linaro.org/thread/ZUWKFSJDBB2EIR6UMX3QU63KRZFN7VTN/
> 
> TL;DR- The uapi structures used in iptables which hold kernel pointers
> are not compatible with the ABI of Linux on the Morello architecture,
> since currently kernel pointers are 64b, but in userspace a * declares
> a capability of size 128b.

Right, this will not work.

> This causes a discrepancy between what the
> kernel expects and what is provided inside some of the netlink
> messages, due to the alignment of structures now being 16B. As a
> result I have had to modify any kernel pointer inside uapi structs to
> be unsigned longs, casting them when used inside the kernel.

i.e. sizeof(unsigned long) == 16 on this architecture?

We cannot change any of these structures unless the layout doesn't
change on 32bit and 64 bit arches.

> Does anyone have any opinion on this method of changing uapi structs
> to not contain kernel pointers? Does simply changing them to unsigned
> long seem sensible, or am I likely to come up against some horrible
> problems I have not yet realised?

No idea, I don't know this architecture.
In iptables, userspace and kernel space exchange binary blobs via
get/setsockopt calls, these binary blobs consists of the relevant
ipt/ip6t/xt_entry structures, matches, targets etc.

Their layout must be the same in userspace and kernel.

If they are not, you lose and only "solution" is more crap added to
CONFIG_NETFILTER_XTABLES_COMPAT.
(The reason for this being a Kconfig option is because I want to remove it).

> When I try to compile iptables using —with-kernel, or —with-ksource, I
> get this error:
> 
> In file included from …/iptables-morello/extensions/libxt_TOS.c:16:
> In file included from …/iptables-morello/extensions/tos_values.c:4:
> In file included from …/kernel-source/include/uapi/linux/ip.h:22:
> In file included from
> …/usr/src/linux-headers-morello/include/asm/byteorder.h:23:
> In file included from
> …/kernel-source/include/uapi/linux/byteorder/little_endian.h:14:
> …/kernel-source/include/uapi/linux/swab.h:48:15: error: unknown type
> name '__attribute_const__'
> 
> I see that this error arises because when I set the —with-kernel flag
> libxt_TOS.c is being compiled against ./include/uapi/linux/ip.h. But
> when I compile without that flag, the -isystem flag value provides the
> ./include/linux/ip.h.

I doubt -—with-kernel is tested at all.

> **Questions**
> 
> I see in the configure.ac script that setting this flag changes the
> includes for the kernel, putting precedence on the uapi versions of
> the headers. This was introduced in commit
> 59bbc59fd2fbbb7a51ed19945d82172890bc40f9 specifically in order to fix
> the fact that —with-kernel was broken. However I read in the INSTALL
> file:
> 
>  “prerequisites…  no kernel-source required “,
> and
> “--with-ksource= … Xtables does not depend on kernel headers anymore…
> probably only useful for development.”
>
> So I wonder, is this —with-kernel feature seldom used/tested and no
> longer working in general?

Not tested, looks like it no longer works.

> Or could my issue be due to the fact that
> this __attribute_const__ is a GCC specific directive and I use clang,
> and this is not being picked up properly when running configure?

No idea, possible.

> What I thought might be a solution to compile with my modified headers
> would be to simply copy over and replace the relevant headers which
> are present in the ./include/linux/ directory of the iptables source
> repo. However, even with unmodified kernel headers this throws up its
> own issues, because I see that there are differences between some of
> these headers in the iptables source and those in the kernel source
> itself.

Yes, but this is unwanted.

> iptables libxt_CONNMARK.c file. The version of the header in the
> iptables source has not been updated to correspond to the current
> kernel header version.
> 
> commit for xt_connmark.h in kernel source:
> 
> commit 472a73e00757b971d613d796374d2727b2e4954d
> Author: Jack Ma <jack.ma@alliedtelesis.co.nz>
> Date:   Mon Mar 19 09:41:59 2018 +1300
> 
> +enum {
> +       D_SHIFT_LEFT = 0,
> +       D_SHIFT_RIGHT,
> +};
> +
> 
> commit for libxt_CONNMARK.c in iptables source:
> 
> commit db7b4e0de960c0ff86b10a3d303b4765dba13d6a
> Author: Jack Ma <jack.ma@alliedtelesis.co.nz>
> Date:   Tue Apr 24 14:58:57 2018 +1200
> 
> +enum {
> +       D_SHIFT_LEFT = 0,
> +       D_SHIFT_RIGHT,
> +};
> +
> 
> I suppose I am generally confused about why iptables uses its own
> bespoke versions of kernel headers in its source, that do not marry up
> with those actually in the kernel repo. Are the headers different for
> backwards compatibility or portability or such?

No, its just that noone has done a full resync in a long time.
The kernel headers are authoritative, but I fear that just replacing
them with recent upstream versions will result in more surprises just
like the ones you found, which need to be fixed up on userspace side.

Why are you interested in getting iptables to work?

It would be better to ensure that nftables is working properly; unlike
with xtables the kernel representation is hidden from userspace.
