From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 2/3] NFQUEUE: coalesce IPv4 and IPv6 hashing
Date: Tue, 2 Apr 2013 01:26:52 +0200
Message-ID: <20130401232651.GB8071@localhost>
References: <20130323200402.209591997@eitzenberger.org>
 <20130323200608.174914056@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Holger Eitzenberger <holger@eitzenberger.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37779 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757993Ab3DAX04 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:26:56 -0400
Content-Disposition: inline
In-Reply-To: <20130323200608.174914056@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 23, 2013 at 09:04:04PM +0100, Holger Eitzenberger wrote:
> Because rev1 and rev3 of the target share the same hashing
> generalize it by introduing nfqueue_hash().

Also applied, thanks.
