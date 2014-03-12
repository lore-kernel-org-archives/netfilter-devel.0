From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: restore context during
 destruction
Date: Wed, 12 Mar 2014 13:23:39 +0100
Message-ID: <20140312122339.GA20453@localhost>
References: <1394215713-32049-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51696 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaCLMXu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:23:50 -0400
Content-Disposition: inline
In-Reply-To: <1394215713-32049-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 07, 2014 at 07:08:28PM +0100, Patrick McHardy wrote:
> The following patches restore the context during expression destruction
> in order to restore notifications for anonmyous set destruction and get
> rid of some unnecessary members in the expressions' private structures.
> 
> Additionally they contain a couple of related minor cleanups.
> 
> Please apply.

All applied, thanks Patrick.
