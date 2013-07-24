From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: additional include path required after UAPI
 changes
Date: Wed, 24 Jul 2013 20:44:56 +0200
Message-ID: <20130724184456.GA885@localhost>
References: <20130721153049.GA8444@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47918 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab3GXSpB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:45:01 -0400
Content-Disposition: inline
In-Reply-To: <20130721153049.GA8444@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 21, 2013 at 08:30:49AM -0700, Phil Oester wrote:
> After kernel commit 607ca46e (UAPI: (Scripted) Disintegrate include/linux),
> using the "--with-kernel" argument to build iptables stopped working due
> to the missing #ifdefs in the original files.  We need to make sure the
> UAPI include dir is listed before the original location.  Leaving both
> allows support for old and new kernels.
> 
> This fixes bug #833.

Applied, thanks Phil.
