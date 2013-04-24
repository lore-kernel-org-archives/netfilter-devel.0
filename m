From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [Nftables RFC] High level library proposal
Date: Wed, 24 Apr 2013 13:23:27 +0200
Message-ID: <1366802607.26911.489.camel@localhost>
References: <516EA684.9040209@linux.intel.com>
	   <20130419100531.GA3481@localhost> <1366661111.26911.361.camel@localhost>
	  <51765F34.6020402@linux.intel.com> <1366742961.26911.440.camel@localhost>
	 <51777660.7090802@linux.intel.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:16291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932231Ab3DXLYE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:24:04 -0400
In-Reply-To: <51777660.7090802@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2013-04-24 at 09:06 +0300, Tomasz Bursztyka wrote:
> Hi Jesper,
> 
> >> >- either via proposing low level functions requesting the cache as you
> >> >propose (and we probably should)
> > I'm a little worried about your idea of implementing a cache.
> > It reminds me of the current libliptc (IPtables Cache) library, which
> > caused a lot of annoying issues in the past.
> > I know, you said we can use the notification system to keep the cache
> > up-to-date, but just have a bad feeling about introducing a cache
> > layer...
> 
> It should be indeed much easier and reliable to maintain a cache with 
> nftables api.
> But you are right: not all usage might require this. That's why I 
> thought about NFT_FLAG_FOLLOW_* flags
> One could limit the "caching" towards only application 
> rules/chain/tables (if any), and other one would keep track of everything.
> 
> >> >- and/or when using nft_execute_statement() it would check if it already
> >> >exist - or not, if it's a delete statement -
> >> >by itself, hiding the details to the dev and raising a success relevantly.
> > So, your are saying that a nft_execute_statement() that creates a rule
> > sound return a "false" indication if the rule already exists?
> > I would really prefer a real "test/query" operation, but I guess we
> > should extend the kernel API to support this, so we don't need a cache
> > infrastructure for this.
> 
> I don't know if such existence test should be part of kernel API rather 
> than in user land since when manipulating
> you need anyway a dump of the rule set.
> 
> But about nft_execute_statement(), it's not really a false indication: 
> you want to inject a rule which already exist, so it's fine.
> Or we could handle it so it return an error like -EALREADY if it's 
> preferable.

Hmm, yes, I see the problem.  It is actually allowed/valid to create
many of the exact same rule...

We definitely need a "test/query/exists" operation.  And it should be
fairly simple to implement, as its very similar to a "delete" rule
operation, which simply don't actually delete the rule, but just returns
if it was "possible" to delete such a rule.
(but again a kernel side changes)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer


