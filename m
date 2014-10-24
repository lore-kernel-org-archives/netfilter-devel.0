From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] meta: Add support for datatype devgroup
Date: Fri, 24 Oct 2014 12:06:14 +0200
Message-ID: <20141024100614.GA4921@salvia>
References: <1ee461886f3f61ce6dece0fad0c7a2322d1d5153.1414068114.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43108 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009AbaJXKEr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Oct 2014 06:04:47 -0400
Content-Disposition: inline
In-Reply-To: <1ee461886f3f61ce6dece0fad0c7a2322d1d5153.1414068114.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 23, 2014 at 02:44:19PM +0200, Ana Rey wrote:
> This adds the new devgroup datatype to get the group name from
> /etc/iproute2/group file.
> 
> Example of use:
> 
> nft add rule ip test input meta iifgroup 0 counter
> nft add rule ip test input meta iifgroup default counter
> 
> Moreover, It adds tests in meta.t test file.

Applied, thanks.

