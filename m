Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4A079DC7
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Aug 2024 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723050423; cv=none; b=C4Pu4IDfizmQodGE4NjOwdlKQYa91Inf8e0VOkF3RPFxu+5Qdjsp5EvqpX6V4SNVm8NhF0ES+S0vf3AhI84dbIVBc0p6s4Oa06FE8uoaroz4rLufrwALUk0A9arlVHS15PXwZpWnTadWanwKXibsxWBRwJ9f5oabnvwU/JzMT14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723050423; c=relaxed/simple;
	bh=mjPsOkwP59uhBnIo9SQ+09zXV0lxkbOsZg/5d3KXzgc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaTfRVf/edV29nP6U7QyFsw2hE9JYJC6cJrZ1rrScyyjxHmjKMsnLucVQHUZGW5jonnQ5Qp+Xqh0QO5pjp5bv3by1mxQpIiitFzK/nzqgGEqknkvyhWhYe44SgjGbxpvuYq8Vl6SEM16vzRTmEvEAIozL5DxrGR13ZUr3sH9OCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=KOk+dQMY; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="KOk+dQMY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vuKqRf2Obl/oTIUvwCjYACjuMK+8I9BvbBlU3rneZMI=; b=KOk+dQMYmpQbZWXP8ClhOO2sAc
	HFrmw9LA9DAGuQ7XADzaG5fE5fiEU5LKtk4/iBUKAVyU9R307Rsc+UQeEpKf1TPBmzT1u/+P3DnYv
	PkGMzi7Jws3veYchF1rzcEVULg3hWI54uT6iHhRHb5lKYUSWqqVAhkG/pVEXsLvoOr3Yvlk0SgOVK
	+EBuY6PeY4TK+0/xWkQjMCJ2azDX8PubfuLbUAC5XuY85r+vXWhpglYxmPs5AcqtQ8WyDyf1w6fqW
	HViSo9LA6ZU/dpD5VMTW82d1PJo5+CxK0aY1ajRgbQDNeln22VXYB2EP8Wl8490TKmN1fqtYgGfzH
	A9+qXorQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sbk7f-000000004PV-247W;
	Wed, 07 Aug 2024 19:06:51 +0200
Date: Wed, 7 Aug 2024 19:06:51 +0200
From: Phil Sutter <phil@nwl.cc>
To: josh lant <joshualant@googlemail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: compiling with kernel headers
Message-ID: <ZrOpqyQZZW1wUTUQ@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	josh lant <joshualant@googlemail.com>,
	netfilter-devel@vger.kernel.org
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

Hi Josh,

On Wed, Aug 07, 2024 at 03:36:01PM +0100, josh lant wrote:
> Hi,
> 
> Apologies in advance for the long post… I wonder if someone could help
> me understand the architecture of the iptables codebase, particularly
> its use of kernel headers…
> 
> **Background**
> 
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
> a capability of size 128b. This causes a discrepancy between what the
> kernel expects and what is provided inside some of the netlink
> messages, due to the alignment of structures now being 16B. As a
> result I have had to modify any kernel pointer inside uapi structs to
> be unsigned longs, casting them when used inside the kernel.
> 
> Does anyone have any opinion on this method of changing uapi structs
> to not contain kernel pointers? Does simply changing them to unsigned
> long seem sensible, or am I likely to come up against some horrible
> problems I have not yet realised?

I won't comment on the above, as it seems like a generic issue with
porting GNU/Linux to Morello, not an iptables-specific one.

> **Issue**
> 
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

I can't reproduce this here.

> I see that this error arises because when I set the —with-kernel flag
> libxt_TOS.c is being compiled against ./include/uapi/linux/ip.h. But
> when I compile without that flag, the -isystem flag value provides the
> ./include/linux/ip.h.

What './include/linux/ip.h' is that? It's not in iptables.git. On my
system, /usr/include/linux/ip.h is basically identical to
include/uapi/linux/ip.h in my clone of linux.git.

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

Yeah, we cache needed kernel headers in iptables.git.

> So I wonder, is this —with-kernel feature seldom used/tested and no
> longer working in general? Or could my issue be due to the fact that
> this __attribute_const__ is a GCC specific directive and I use clang,
> and this is not being picked up properly when running configure?

Did you retry using gcc? I personally don't use --with-kernel/ksource,
so from my very own perspective, this feature is unused and untested. ;)

> What I thought might be a solution to compile with my modified headers
> would be to simply copy over and replace the relevant headers which
> are present in the ./include/linux/ directory of the iptables source
> repo. However, even with unmodified kernel headers this throws up its
> own issues, because I see that there are differences between some of
> these headers in the iptables source and those in the kernel source
> itself.

These are bugs IMO. Kernel headers are supposed to be compatible, so one
should not have to adjust user space for newer headers - the problem
with xt_connmark.h is an exception to the rule in my perspective.

> One example of these differences is in xt_connmark.h, leading to
> errors with duplication of declarations when compiling
> libxt_CONNMARK.c using the headers from the kernel source… In the
> iptables source the libxt_CONNMARK.c file defines D_SHIFT_LEFT.
> However, in the latest version of xt_connmark.h in the kernel, this
> enum definition is in the header, so it needs to be removed from the
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

It's odd that Jack apparently preferred to copy that enum into the
source instead of updating the cached header. Oddly, he added the
definiton of struct xt_connmark_tginfo2 to the cached header in the same
commit.

> I suppose I am generally confused about why iptables uses its own
> bespoke versions of kernel headers in its source, that do not marry up
> with those actually in the kernel repo. Are the headers different for
> backwards compatibility or portability or such?

They are there for compatibility reasons, mostly to gain some
independence from host systems compiling the sources.

If it helps you, feel free to submit a patch updating the cached
xt_connmark.h and dropping said enum from libxt_CONNMARK.c. Same for
other issues you noticed. In doubt just send me a report and I'll see
how I can resolve things myself.

Thanks, Phil
