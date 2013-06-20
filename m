From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 11:42:43 +0200
Message-ID: <20130620094243.GA5703@localhost>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
 <51C17E26.2020608@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58865 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3FTJmu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:42:50 -0400
Content-Disposition: inline
In-Reply-To: <51C17E26.2020608@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 19, 2013 at 12:47:18PM +0300, Tomasz Bursztyka wrote:
> Hi Eric,
>
> >The patch
> >	netfilter: nf_tables: add insert operation
> >adds support for inserting a rule after a handle.
> >
> >It is followed by the patch
> >	examples: add insert rule example
> >which is the libnftables example.
> >
> >I choose to reuse the CREATE operation in the kernel code
> >to avoid to add a new message to netlink. This way we have
> >a sort of 'create after' syntax. This is almost natural IMHO.
> 
> There is an issue however: notification.
> I don't see how other clients are going to know where to put the
> rule when updating there own list when they get notified.
> 
> They will be notified that a rule as been added successfully, but
> they will get it as an appended rule.

This can be implemented in user-space.

The user-space daemon can keep a cache of the ordered rule-set. Thus,
it can guess the position of the rule-set from the handle.
