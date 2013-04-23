From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Tue, 23 Apr 2013 20:49:21 +0200
Message-ID: <1366742961.26911.440.camel@localhost>
References: <516EA684.9040209@linux.intel.com>
	  <20130419100531.GA3481@localhost> <1366661111.26911.361.camel@localhost>
	 <51765F34.6020402@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Eric Leblond <eric@regit.org>,
	Julien Vehent <julien@linuxwall.info>,
	Fabio Di Nitto <fdinitto@redhat.com>,
	Jiri Benc <jbenc@redhat.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	Thomas Graf <tgraf@redhat.com>,
	Thomas Woerner <twoerner@redhat.com>
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757023Ab3DWSui (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Apr 2013 14:50:38 -0400
In-Reply-To: <51765F34.6020402@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2013-04-23 at 13:15 +0300, Tomasz Bursztyka wrote:
> Hi Jesper,
> 
> > First of all, thanks Tomasz for proposing to write a high level API for
> > nftables.
> 
> We all need this and I know I will not be alone implementing it.
> 
> > Use-case 1
> > ----------
> > At ComX Networks, I needed to build a "SubnetSkeleton" tree structure
> > with iptables
> > (https://github.com/netoptimizer/IPTables-SubnetSkeleton/blob/master/lib/IPTables/SubnetSkeleton.pm#L440)
> >
> > For this I needed some API calls, to query if some rules and chains
> > already existed.  There was an API for testing if a chain existed, I
> > used when building the tree.  And the assumed that the jump rule in/to
> > the chain was correct, as no API existed for asking if a rule existed,
> >
> > To avoid inserting a rule twice, I solved this by the hack of simply
> > first delete the rule, and the insert the rule.  I would really have
> > liked a test if rule exist API instead.
> 
> I stumble into the same use case with iptables and indeed it got solved 
> the same way.
> 
> But since we are dealing with much better kernel stack, we could solve 
> this differently:

Yes, our current iptables devel API 'libiptc' is broken, and not even
officially supported/exported.  So, lets create something better this
time around.


> - either via proposing low level functions requesting the cache as you 
> propose (and we probably should)

I'm a little worried about your idea of implementing a cache.
It reminds me of the current libliptc (IPtables Cache) library, which
caused a lot of annoying issues in the past.
I know, you said we can use the notification system to keep the cache
up-to-date, but just have a bad feeling about introducing a cache
layer...


> - and/or when using nft_execute_statement() it would check if it already 
> exist - or not, if it's a delete statement -
> by itself, hiding the details to the dev and raising a success relevantly.

So, your are saying that a nft_execute_statement() that creates a rule
sound return a "false" indication if the rule already exists?
I would really prefer a real "test/query" operation, but I guess we
should extend the kernel API to support this, so we don't need a cache
infrastructure for this.




> > Use-case 2
> > -----------
> > Think this was Fabio's use-case during the netfilter workshop.
> >
> > An interface to dry run a packet through configured netfilter policy.
> >
> > This would allow user space to figure out if a specific daemon or
> > use-case can function in the configured environment.
> >
> > The feature is primarily intended for debugging and troubleshooting
> > purposes but can be extended later on, enabling daemons or daemon
> > management tools to verify if the daemon is permitted to run in the
> > configured specific environment.
> >
> > I guess, we also would need some kernel changes for supporting this?
> 
> Indeed, it needs to be thought and implemented there first.

Yes, some kernel work is required here.


-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer


