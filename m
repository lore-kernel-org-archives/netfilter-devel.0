From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/5] netfilter: nf_conntrack: remove net_ratelimit() for
 LOG_INVALID()
Date: Wed, 31 Jul 2013 18:53:42 +0200
Message-ID: <20130731165342.GB13813@localhost>
References: <1375044851-12471-1-git-send-email-kaber@trash.net>
 <1375044851-12471-2-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51114 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760461Ab3GaQxr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 12:53:47 -0400
Content-Disposition: inline
In-Reply-To: <1375044851-12471-2-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 28, 2013 at 10:54:07PM +0200, Patrick McHardy wrote:
> Logging of invalid packets has to be explicitly enabled. Rate-limiting these
> messages is inconsistent with other netfilter logging features and makes
> debugging harder.

Applied, thanks Patrick!
