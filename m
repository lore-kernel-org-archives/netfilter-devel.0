From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables 2/3] erec: fix logic when reading from file
Date: Tue, 30 Jun 2015 02:03:10 +0200
Message-ID: <20150630000310.GB6449@salvia>
References: <1435132311-31452-1-git-send-email-eric@regit.org>
 <1435132311-31452-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38170 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbbF2X5m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jun 2015 19:57:42 -0400
Content-Disposition: inline
In-Reply-To: <1435132311-31452-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 24, 2015 at 09:51:50AM +0200, Eric Leblond wrote:
> In case we are reading the rules from a file we need to reset the
> file descriptor to the original position when calling erec_print.
> 
> This was not the case in previous code and was leading to valid
> file to be seen as invalid when treated in debug mode.

Also applied, thanks.


