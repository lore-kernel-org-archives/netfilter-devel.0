From: Patrick McHardy <kaber@trash.net>
Subject: Re: xtables: consistent struct compat_xt_counters definition
Date: Wed, 10 Feb 2010 15:00:55 +0100
Message-ID: <4B72BC17.60204@trash.net>
References: <20100205221142.GB27953@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51160 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab0BJOA7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 09:00:59 -0500
In-Reply-To: <20100205221142.GB27953@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> There is compat_u64 type which deals with different u64 type alignment
> on different compat-capable platforms, so use it and removed some
> hardcoded assumptions.

Applied, thanks.
