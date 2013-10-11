From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack-tools] nfct: Fix use-after-free / double-free
Date: Fri, 11 Oct 2013 22:45:10 +0200
Message-ID: <20131011204510.GA20608@localhost>
References: <20131011200534.GD2728@doj>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hani Benhabiles <kroosec@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab3JKUpO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 16:45:14 -0400
Content-Disposition: inline
In-Reply-To: <20131011200534.GD2728@doj>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 11, 2013 at 09:05:34PM +0100, Hani Benhabiles wrote:
> helper's list and flush commands handlers shouldn't call mnl_socket_close on the
> passed netlink socket as it is done in the main function after parse_params
> call.

Applied, thanks Hani.
