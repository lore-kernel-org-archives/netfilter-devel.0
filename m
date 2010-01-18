From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] xtables: add struct xt_mtchk_param::net
Date: Mon, 18 Jan 2010 08:24:02 +0100
Message-ID: <4B540C92.6050106@trash.net>
References: <20100116185453.GB24605@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47767 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0ARHYG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 02:24:06 -0500
In-Reply-To: <20100116185453.GB24605@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Some complex match modules (like xt_hashlimit/xt_recent) want netns
> information at constructor and destructor time. We propably can play
> games at match destruction time, because netns can be passed in object,
> but I think it's cleaner to explicitly pass netns.

Agreed.

> Add ->net, make sure it's set from ebtables/iptables/ip6tables code.

Applied, but I once again had to fix up several instances of overly
long lines. I'm tired of repeating these trivial things every time
you send me a patch, next time I'll silently drop them.
