From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/6] src: chain: Free memory in the same
 function that is reserved
Date: Mon, 30 Jun 2014 12:42:00 +0200
Message-ID: <20140630104200.GA6348@localhost>
References: <1403800740-10572-1-git-send-email-anarey@gmail.com>
 <1403800740-10572-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56045 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaF3KmF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:42:05 -0400
Content-Disposition: inline
In-Reply-To: <1403800740-10572-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 26, 2014 at 06:38:55PM +0200, Ana Rey wrote:
> Free memory in the same function that is reserved.

Applied, thanks.
