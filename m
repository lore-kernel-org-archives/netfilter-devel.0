From: Florian Westphal <fw@strlen.de>
Subject: Re: Non-Understood Message
Date: Tue, 13 Nov 2012 23:53:31 +0100
Message-ID: <20121113225331.GG20678@breakpoint.cc>
References: <50A2A40E.5050802@cats-muvva.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Nicole <nicole@cats-muvva.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:32971 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045Ab2KMWxd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2012 17:53:33 -0500
Content-Disposition: inline
In-Reply-To: <50A2A40E.5050802@cats-muvva.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nicole <nicole@cats-muvva.net> wrote:
> MYTARGET.0 target: invalid size 65540 (kernel) != (user) 4

[..]

> struct xt_mytarget_tginfo {
>     __u8    value;
> 
>     __u8    mode;
> 
>     bool    final;
> 
>     bool    set_value;
> 
>     __u8    by_port[USHRT_MAX];
> };

Its too large.  The kernel <-> userspace abi encodes size
in 'u16' datatype, thus the target size sent by userspace overflows.
