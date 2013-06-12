From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH 2/2] counter: fix restoration
Date: Wed, 12 Jun 2013 11:43:53 +0200
Message-ID: <20130612094353.GB4498@localhost>
References: <1370732927-23322-1-git-send-email-eric@regit.org>
 <1370732927-23322-3-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39751 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab3FLJn6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:43:58 -0400
Content-Disposition: inline
In-Reply-To: <1370732927-23322-3-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 09, 2013 at 01:08:47AM +0200, Eric Leblond wrote:
> It was not possible to restore a ruleset countaining counter. The
> packets and bytes fields were not known from the parser but they
> were in the output of the list command.
> This patch fixes the issue by restoring correctly the counters if
> they are present in the command.

Applied, thanks Eric.
