From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: Add meta expression key for bridge
 interface name
Date: Wed, 26 Mar 2014 12:12:55 +0000
Message-ID: <20140326121255.GA1375@macbook.localnet>
References: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33995 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaCZMM7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:12:59 -0400
Content-Disposition: inline
In-Reply-To: <1395765587-5399-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 25, 2014 at 06:39:47PM +0200, Tomasz Bursztyka wrote:
> NFT_META_IBRIFNAME to get packet input bridge interface name
> NFT_META_OBRIFNAME to get packet output bridge interface name

Minor request: NFT_META_BRI_IIFNAME and NFT_META_BRI_OIFNAME.
