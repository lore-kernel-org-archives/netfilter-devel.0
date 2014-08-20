From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] payload: use proto_unknown for raw protocol
 header
Date: Wed, 20 Aug 2014 15:19:08 +0200
Message-ID: <20140820131908.GA7073@salvia>
References: <1407589277-15812-1-git-send-email-yshuiv7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tomasz.bursztyka@linux.intel.com, netfilter-devel@vger.kernel.org
To: Yuxuan Shui <yshuiv7@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49461 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468AbaHTNSn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:18:43 -0400
Content-Disposition: inline
In-Reply-To: <1407589277-15812-1-git-send-email-yshuiv7@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Aug 09, 2014 at 09:01:17PM +0800, Yuxuan Shui wrote:
> Otherwise payload.desc would be NULL, which causes the crash in bug 915.

Applied, thanks.

