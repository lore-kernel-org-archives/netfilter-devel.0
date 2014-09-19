From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libxt_devgroup: Fix the path of the mappings
 file
Date: Fri, 19 Sep 2014 15:18:20 +0200
Message-ID: <20140919131820.GA8146@salvia>
References: <1411038402-7711-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbaISNRX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 09:17:23 -0400
Content-Disposition: inline
In-Reply-To: <1411038402-7711-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 18, 2014 at 01:06:42PM +0200, Ana Rey wrote:
> Use "/etc/iproute2/group" like the path of the mapping file instead of
> "/etc/iproute2/group_map"

Applied, thanks Ana.

