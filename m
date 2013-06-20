From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ct: check return code from
 nla_parse_tested
Date: Thu, 20 Jun 2013 11:45:00 +0200
Message-ID: <20130620094500.GA6225@localhost>
References: <1371052491-23863-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59368 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695Ab3FTJpE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:45:04 -0400
Content-Disposition: inline
In-Reply-To: <1371052491-23863-1-git-send-email-dborkman@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 12, 2013 at 05:54:51PM +0200, Daniel Borkmann wrote:
> These are the only calls under net/ that do not check nla_parse_nested()
> for its error code, but simply continue execution. If parsing of netlink
> attributes fails, we should return with an error instead of continuing.
> In nearly all of these calls we have a policy attached, that is being
> type verified during nla_parse_nested(), which we would miss checking
> for otherwise.

Applied, thanks Daniel.

I'm going to run some tests, this may uncover wrong policies as they
were not enforced.
