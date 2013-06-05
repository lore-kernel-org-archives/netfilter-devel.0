From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] nft-events: add newline to output
Date: Wed, 5 Jun 2013 05:52:41 +0200
Message-ID: <20130605035241.GB1504@localhost>
References: <1370333124-11674-1-git-send-email-eric@regit.org>
 <1370333124-11674-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33311 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab3FEDwz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 23:52:55 -0400
Content-Disposition: inline
In-Reply-To: <1370333124-11674-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 04, 2013 at 10:05:22AM +0200, Eric Leblond wrote:
> This patch adds a new line to messages to be sure that they are
> printed to the shell as soon as they occur. This also fixes the
> display of output.

Applied, thanks Eric.
