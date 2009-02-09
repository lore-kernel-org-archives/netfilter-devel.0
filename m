From: Patrick McHardy <kaber@trash.net>
Subject: Re: [iptables] xt_NFLOG: Set default NFLOG qthreshold to 0
Date: Mon, 09 Feb 2009 18:34:32 +0100
Message-ID: <49906928.9020509@trash.net>
References: <1233354708-22009-1-git-send-email-eric@inl.fr> <1233354708-22009-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756704AbZBIRei (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:34:38 -0500
In-Reply-To: <1233354708-22009-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> By setting default NFLOG qthreshold to 0, userspace does not overwrite
> the per-instance value.

Also applied, thanks.
