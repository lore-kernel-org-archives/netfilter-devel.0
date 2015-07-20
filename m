From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Fix memory leak in nf_register_net_hook
Date: Mon, 20 Jul 2015 09:14:38 +0200
Message-ID: <20150720071438.GA3826@salvia>
References: <20150718075610.GD5422@mwanda>
 <87si8lh4ph.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
	netfilter-devel@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39590 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753669AbbGTHIw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 03:08:52 -0400
Content-Disposition: inline
In-Reply-To: <87si8lh4ph.fsf@x220.int.ebiederm.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 18, 2015 at 10:21:14AM -0500, Eric W. Biederman wrote:
> 
> In the rare case that when it is a attempted to use a per network device
> netfilter hook and the network device does not exist the newly allocated
> structure can leak.
> 
> Be a good citizen and free the newly allocated structure in the error
> handling code.

Applied.
