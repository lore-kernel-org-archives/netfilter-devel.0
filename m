From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/1] add insert after to nf_tables
Date: Thu, 20 Jun 2013 12:10:12 +0200
Message-ID: <20130620101012.GA19679@localhost>
References: <1371628997-13548-1-git-send-email-eric@regit.org>
 <51C17E26.2020608@linux.intel.com>
 <20130620094243.GA5703@localhost>
 <51C2D0D8.1020309@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40380 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965007Ab3FTKKR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:10:17 -0400
Content-Disposition: inline
In-Reply-To: <51C2D0D8.1020309@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 20, 2013 at 12:52:24PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> 
> >The user-space daemon can keep a cache of the ordered rule-set. Thus,
> >it can guess the position of the rule-set from the handle.
> 
> Hum, how?
> The handle it will get from the notification is the handle of the
> newly created rule, not the one used to identify the rule for
> insertion.

That's right. I don't come with any other way to make it rather than
adding a new attribute.

Eric, would you rework the patch to do so?
