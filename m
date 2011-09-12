From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC] iptables-restore: new option to change the commit
 timing
Date: Mon, 12 Sep 2011 11:28:07 +0200
Message-ID: <20110912092807.GB2194@1984>
References: <4E68C314.3070709@dump-Storage.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Hiroshi KIHIRA <hiro@dump-Storage.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab1ILJ2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 05:28:09 -0400
Content-Disposition: inline
In-Reply-To: <4E68C314.3070709@dump-Storage.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 08, 2011 at 10:28:52PM +0900, Hiroshi KIHIRA wrote:
> Hi,
> 
> I propose to add a new command line option to iptables-restore.
> The following patch introduces a new command line option which changes
> the timing of the action of table commitment.
> 
> In the situation that some tables are restored, each of tables are
> applied into the kernel space when the COMMIT statement was read from
> the input. If there was a syntax error in rules, iptables-restore
> will end without doing any modification to the table. However the
> table that was already committed into kernel space does not reverted.
> It causes a inconsistency between the tables. (e.g., some marked
> packets are dropped at filter table, but do not marked any packet at
> mangle table)

I think people should call iptables-restore -T to test the rule-set
before, at least the first time the have saved the rule-set, to make
sure that they don't run into inconsistencies.

Applying the rule-set partially for one table may also result in
inconsistencies, so I still don't see what we gain from allowing this.
