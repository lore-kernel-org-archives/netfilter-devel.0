From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables-nftables PATCH 2/3] libxtables: Port libarptc mangle
 target into libxtables
Date: Thu, 3 Oct 2013 12:36:06 +0200
Message-ID: <20131003103606.GA15817@localhost>
References: <1380793977-9730-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1380793977-9730-3-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20131003103229.GB15413@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44878 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753552Ab3JCKgL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Oct 2013 06:36:11 -0400
Content-Disposition: inline
In-Reply-To: <20131003103229.GB15413@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 03, 2013 at 12:32:29PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 03, 2013 at 12:52:56PM +0300, Tomasz Bursztyka wrote:
> > Refactoring original code so functions fits with xtables_target
> > structure.
> 
> Also applied, thanks.

We need a follow up fix for this:

xtables-arp  -A  OUTPUT  -o  eth1  --h-length  6  -j mangle --mangle-mac-s 01:00:5e:00:01:01
xtables-arp v1.4.19.1: Extension mangle uses invalid ID 49
