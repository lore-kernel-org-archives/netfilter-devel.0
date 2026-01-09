Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C24E332EC1;
	Fri,  9 Jan 2026 10:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767954024; cv=none; b=RS/wIXC1Fw4AEilVPTp8TvnG5dHhh2NKc/yxt7tvfPcCJyjyQNZouVhrRnGB6IsFpT3m/GIAW9d/58AmDMmHmwhOroTcLmkoItSw+7fK00zbSdMZkn+70lswBEfCwJF8Akt5aLfkIzMZ5VScnRQhEGj22+oAmdCxtnc2NouXa8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767954024; c=relaxed/simple;
	bh=Vk4OZ/PEc1O7ibxUtTzycjNMCMNgkop2WVagX7RPjaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Srv+QvgQiemD8ADkaFHqlqL+WDzlS/T74K3pe8/H3Fd+H1wPh5btw/CSzyY8P1q7PqjMEGQkeIrWg/AGFLcDQwK89blwVbJnTKpUhJDE/wckP98+jplJ6hKxCCMrDWd9cUUmtW0FFZNZbbF5a8mRYnTk4MMMrwWnNsNThtY3DjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=e6Ziy3SV; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=NSJEd+Cw; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="e6Ziy3SV";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="NSJEd+Cw"
Date: Fri, 9 Jan 2026 11:20:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1767954022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFQeCjkrXgiJngG+qWy9Fm2wUdJK/cbETOpn2vAazqE=;
	b=e6Ziy3SV0yxTWH+S+STwEca9J9UluhcfHljAWwcsjhMu0hxuC9onAD47PzRMoAmbERl9ZS
	9nQKZRwsV/kONWbUsvD4TdNSLXWygn7caC/8pNLihdMCfFpgP89fcZZ4Gz4SHNC4NhZE1E
	9dlrzret2TK89ETwqmpagWIJE6PdljC/iXJV5hzWmTrpoM7wbRf01ivmdXM827lAHt1WPU
	jmraEpSdr/bEXPVU+Zm/s9Evr130CvN1iswY+65C7APDP8cebAXEoaYYpZYchxXGDbSKw5
	fy9NItmZ8xnA54KJey9jCXRetO86IdTIZCayoStaCMIK+2OEJABgeB3wduyTcg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1767954022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uFQeCjkrXgiJngG+qWy9Fm2wUdJK/cbETOpn2vAazqE=;
	b=NSJEd+CwdGdhWdVp0gmpgP3M8CymxGdbMXgcIJ1BfUwR/2Im2OAA6IBOin6psBUaTzgMq8
	roPWlGTECikhRyDg==
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>, 
	Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, linux-kernel@vger.kernel.org, 
	Netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH RFC net-next 3/3] netfilter: uapi: Use UAPI definition of
 INT_MAX and INT_MIN
Message-ID: <20260109111310-4b387d2e-1459-4701-9e58-dc02ad74c499@linutronix.de>
References: <20260105-uapi-limits-v1-0-023bc7a13037@linutronix.de>
 <20260105-uapi-limits-v1-3-023bc7a13037@linutronix.de>
 <d3554d2d-1344-45f3-a976-188d45415419@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d3554d2d-1344-45f3-a976-188d45415419@app.fastmail.com>

On Mon, Jan 05, 2026 at 02:02:17PM +0100, Arnd Bergmann wrote:
> On Mon, Jan 5, 2026, at 09:26, Thomas Weiﬂschuh wrote:
> > Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
> > dependency on a libc, which UAPI headers should not do.
> >
> > Use the equivalent UAPI constants.
> >
> > Signed-off-by: Thomas Weiﬂschuh <thomas.weissschuh@linutronix.de>
> 
> I agree with the idea of the patch series, but I think this
> introduces a different problem:
> 
> >  #include <linux/in.h>
> > +#include <linux/limits.h>
> 
> linux/limits.h is not always clean against limits.h. In glibc,
> you can include both in any order, but in musl, you cannot:
> 
> gcc -xc /dev/null -nostdinc -I /usr/include/aarch64-linux-musl -include limits.h -include linux/limits.h  -o - -Wall  -c 
> In file included from <command-line>:
> /usr/include/aarch64-linux-musl/linux/limits.h:7: warning: "NGROUPS_MAX" redefined
>     7 | #define NGROUPS_MAX    65536    /* supplemental group IDs are available */
>       | 
> In file included from <command-line>:
> /usr/include/aarch64-linux-musl/limits.h:48: note: this is the location of the previous definition
>    48 | #define NGROUPS_MAX 32

Ack.

> I can think of two alternative approaches here:
> 
> - put the __KERNEL_INT_MIN into a different header -- either a new one
>   or maybe uapi/linux/types.h

> - use the compiler's built-in __INT_MIN__ instead of INT_MIN in
>   UAPI headers.

If we can rely on compiler built-ins I would prefer this option.

> On the other hand, there are a few other uapi headers
> that already include linux/limits.h:
> 
> include/uapi/linux/auto_fs.h:#include <linux/limits.h>
> include/uapi/linux/fs.h:#include <linux/limits.h>
> include/uapi/linux/netfilter/xt_bpf.h:#include <linux/limits.h>
> include/uapi/linux/netfilter/xt_cgroup.h:#include <linux/limits.h>
> include/uapi/linux/netfilter/xt_hashlimit.h:#include <linux/limits.h>

...


Thomas
