From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv5] netfilter: nf_tables: add insert operation
Date: Fri, 19 Jul 2013 14:49:47 +0200
Message-ID: <20130719124947.GA31908@localhost>
References: <1373969264.22759.14.camel@ice-age.regit.org>
 <1374219946-19147-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48542 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab3GSMtv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 08:49:51 -0400
Content-Disposition: inline
In-Reply-To: <1374219946-19147-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jul 19, 2013 at 09:45:46AM +0200, Eric Leblond wrote:
> This patch adds a new rule attribute NFTA_RULE_POSITION which is
> used to store the position of a rule relatively to the others.
> By providing a create command and specifying a position, the rule is
> inserted after the rule with the handle equal to the provided
> position.
> Regarding notification, the position attribute is added to specify
> the handle of the previous rule.

Applied, thanks a lot Eric!
