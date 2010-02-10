From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xtables: symmetric COMPAT_XT_ALIGN definition
Date: Wed, 10 Feb 2010 15:04:08 +0100
Message-ID: <4B72BCD8.7000501@trash.net>
References: <20100205221331.GC27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51252 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab0BJOEO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:04:14 -0500
In-Reply-To: <20100205221331.GC27953@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Rewrite COMPAT_XT_ALIGN in terms of dummy structure hack.
> Compat counters logically have nothing to do with it.
> Use ALIGN() macro while I'm at it for same types.

Also applied, thanks.
