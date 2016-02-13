From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next v2 1/2] netfilter: bridge: add nf_afinfo to
 enable queuing to userspace
Date: Sun, 14 Feb 2016 00:45:22 +0100
Message-ID: <20160213234522.GD10352@breakpoint.cc>
References: <1455202396-5334-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1455202396-5334-2-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: stephane.ml.bryant@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34341 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751105AbcBMXpY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Feb 2016 18:45:24 -0500
Content-Disposition: inline
In-Reply-To: <1455202396-5334-2-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

stephane.ml.bryant@gmail.com <stephane.ml.bryant@gmail.com> wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> This just adds and registers a nf_afinfo for the ethernet
> bridge, which enables queuing to userspace for the AF_BRIDGE
> family. No checksum computation is done.

I think that using empty stub functions is ok for now,
we can add checksum manipulation or mac header save/restore later on.
