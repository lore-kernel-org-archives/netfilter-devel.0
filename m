From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Mon, 12 Sep 2011 20:19:02 +0200
Message-ID: <20110912181902.GB3641@1984>
References: <4E68C314.3070709@dump-Storage.net>
 <20110912092807.GB2194@1984>
 <4E6DF29B.3020901@dump-Storage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hiroshi KIHIRA <hiro@dump-Storage.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60507 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1ILSTF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:19:05 -0400
Content-Disposition: inline
In-Reply-To: <4E6DF29B.3020901@dump-Storage.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2011 at 08:52:59PM +0900, Hiroshi KIHIRA wrote:
> (11/09/12 18:28), Pablo Neira Ayuso wrote:
> >I think people should call iptables-restore -T to test the rule-set
> >before, at least the first time the have saved the rule-set, to make
> >sure that they don't run into inconsistencies.
> >
> >Applying the rule-set partially for one table may also result in
> >inconsistencies, so I still don't see what we gain from allowing this.
> 
> Yes, The inconsistencies from syntax error can be avoided by -t/--test
> option.
> 
> But, if the iptables-restore used in a rule generation script and it
> fails, inconsistencies will occur. So, I think that the iptables-restore
> should avoid the inconsistencies even if the wrong rule-set was inputted
> at the real run.

Still, that run-generation script should run the -t option before it
tries to push the new rule-set, IMO.

> Also, I think that the iptables-restore needs rollback capability for the
> situation of iptc_commit failure.

This problem seems complex to me. You may rollback to the previous
rule-set in the table, but this may be inconsistent with other rules
in tables that did not fail.

The rollback facility is not a guarantee that we are in consistent
state.

That's why I think we should test the rule-set before it is
applied to make sure we don't enter any inconsistent state.
