From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCHv3 1/2] netfilter: REJECT: separate reusable code
Date: Mon, 30 Dec 2013 18:18:20 +0100
Message-ID: <20131230171820.GA21208@localhost>
References: <1388155892.6117.7.camel@ice-age2.regit.org>
 <1388316494-1194-1-git-send-email-eric@regit.org>
 <1388316494-1194-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36792 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3L3RS0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:18:26 -0500
Content-Disposition: inline
In-Reply-To: <1388316494-1194-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 29, 2013 at 12:28:13PM +0100, Eric Leblond wrote:
> This patch prepares the addition of TCP reset support in
> the nft_reject module by moving reusable code into a header
> file.

Applied, thanks Eric.
