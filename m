From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Mon, 22 Apr 2013 22:05:11 +0200
Message-ID: <1366661111.26911.361.camel@localhost>
References: <516EA684.9040209@linux.intel.com>
	 <20130419100531.GA3481@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>,
	Fabio Di Nitto <fdinitto@redhat.com>,
	Jiri Benc <jbenc@redhat.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	Thomas Graf <tgraf@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab3DVUFw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:05:52 -0400
In-Reply-To: <20130419100531.GA3481@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


First of all, thanks Tomasz for proposing to write a high level API for
nftables.


Note to cc'ed people not on the netfilter-devel list can follow the
thread here:
http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/46734


On Fri, 2013-04-19 at 12:05 +0200, Pablo Neira Ayuso wrote:

> I think a good way to see the API proposal is to write a batch of
> use-case example code. So we can all see how the workflow with the
> library will look like before any real library code is written.

Use-case 1
----------
At ComX Networks, I needed to build a "SubnetSkeleton" tree structure
with iptables
(https://github.com/netoptimizer/IPTables-SubnetSkeleton/blob/master/lib/IPTables/SubnetSkeleton.pm#L440)

For this I needed some API calls, to query if some rules and chains
already existed.  There was an API for testing if a chain existed, I
used when building the tree.  And the assumed that the jump rule in/to
the chain was correct, as no API existed for asking if a rule existed,

To avoid inserting a rule twice, I solved this by the hack of simply
first delete the rule, and the insert the rule.  I would really have
liked a test if rule exist API instead.


Use-case 2
-----------
Think this was Fabio's use-case during the netfilter workshop.

An interface to dry run a packet through configured netfilter policy.

This would allow user space to figure out if a specific daemon or
use-case can function in the configured environment.

The feature is primarily intended for debugging and troubleshooting
purposes but can be extended later on, enabling daemons or daemon
management tools to verify if the daemon is permitted to run in the
configured specific environment.

I guess, we also would need some kernel changes for supporting this?


Use-case 3
----------
Related to use-case 2.

Have iptables issue a warning if a new rule would prohibit a well known
service from functioning.

We could use the notification system in nftables to get notified about
some rule changed occurred.  Then we could use the API from use-case 2,
to query if our service is still allowed to work.



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer


