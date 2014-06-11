From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 4/5] src: set: Free memory in the same function
 that is reserved.
Date: Wed, 11 Jun 2014 19:50:35 +0200
Message-ID: <20140611175035.GC17843@localhost>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
 <1402501851-22208-6-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57159 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaFKRuk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:50:40 -0400
Content-Disposition: inline
In-Reply-To: <1402501851-22208-6-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 05:50:50PM +0200, Ana Rey wrote:
> Free memory in the same function that is reserved.

Applied, thanks.
