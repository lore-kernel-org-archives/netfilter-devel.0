From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 1/6] netfilter: ipset: Support comments for ipset entries in the core.
Date: Mon, 02 Sep 2013 10:17:01 +0200
Message-ID: <4272720.GT8HtrGKmD@gentoovm>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <1378103757-14426-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56999 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3IBImI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:42:08 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 9B85EA2D0E
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 09:17:28 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id PlQrsvmDBzrn for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 09:17:06 +0100 (BST)
In-Reply-To: <1378103757-14426-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 02 September 2013 08:35:52 Oliver wrote:
> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> This adds the core support for having comments on ipset entries.
> 
> The comments are stored as standard null-terminated strings in
> dynamically allocated memory after being passed to the kernel. As a
> result of this, any ipset using comments MUST perform cleanup of
> individual entries when being flushed or destroyed in order to ensure
> the allocated memory is released.
> 
> Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

Ignore this patch, it's bad, I'll send a fixed one shortly.

Thanks,
Oliver.
