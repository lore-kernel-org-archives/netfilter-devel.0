From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables tool v2 PATCH 2/4] src: Ensure given base chain type
 is a valid one
Date: Wed, 4 Sep 2013 12:45:50 +0200
Message-ID: <20130904104550.GB8768@localhost>
References: <1378288222-13182-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1378288222-13182-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56334 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934537Ab3IDKpz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:45:55 -0400
Content-Disposition: inline
In-Reply-To: <1378288222-13182-3-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 04, 2013 at 12:50:20PM +0300, Tomasz Bursztyka wrote:
> It verifies at command line parsing that given type is "filter", "nat",
> or "route".

The kernel will just bail out if we pass an invalid chain type.
