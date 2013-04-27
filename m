From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] netfilter: nfqueue: avoid expensive gso segmentation
 and checksum fixup
Date: Sat, 27 Apr 2013 19:46:43 +0200
Message-ID: <20130427174643.GD4891@localhost>
References: <1366383507-16633-1-git-send-email-fw@strlen.de>
 <1366383507-16633-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38792 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab3D0Rqt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Apr 2013 13:46:49 -0400
Content-Disposition: inline
In-Reply-To: <1366383507-16633-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 19, 2013 at 04:58:27PM +0200, Florian Westphal wrote:
> Userspace can now indicate that it can cope with larger-than-mtu sized
> packets and packets that have invalid ipv4/tcp checksums.

And also applied, thanks Florian.
