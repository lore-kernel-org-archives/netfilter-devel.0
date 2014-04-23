From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/5] netfilter: Fix format string mismatch in
 mangle_content_len()
Date: Wed, 23 Apr 2014 14:22:27 +0200
Message-ID: <20140423122227.GA12087@localhost>
References: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org
To: Masanari Iida <standby24x7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55362 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaDWMXF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Apr 2014 08:23:05 -0400
Content-Disposition: inline
In-Reply-To: <1396280619-31152-1-git-send-email-standby24x7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 01, 2014 at 12:43:36AM +0900, Masanari Iida wrote:
> Fix format string mismatch in mangle_connect_len()

Applied, thanks.

P.S: No need to CC linux-kernel and netdev, netfilter-devel is just
fine for these small changes.
