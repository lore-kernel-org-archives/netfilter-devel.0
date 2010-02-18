From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libip4tc: Add static qualifier to dump_entry()
Date: Thu, 18 Feb 2010 18:08:59 +0100
Message-ID: <4B7D742B.3090509@trash.net>
References: <20100218164017.GA19949@wo.int.altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: "Dmitry V. Levin" <ldv@altlinux.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36741 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0BRRJB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:09:01 -0500
In-Reply-To: <20100218164017.GA19949@wo.int.altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dmitry V. Levin wrote:
> Change dump_entry() signature defined in libip4tc.c to match prototype
> declared in libiptc.c and another static dump_entry() function defined
> in libip6tc.c.  This function is not a part of the public libiptc API.

Applied, thanks.
