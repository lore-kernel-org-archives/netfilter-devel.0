From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/2] [RFC] Extended accounting infrastructure for
 iptables
Date: Thu, 15 Dec 2011 14:22:16 +0100
Message-ID: <20111215132216.GA14940@1984>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org>
 <CANtneHJWwcyYhq0U4p6_nc9nDRfpv0_mwGZm_DKr1pHd+urU4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, jengelh@medozas.de, thomas.jarosch@intra2net.com
To: Pete Holland <pholland27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35923 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab1LONWY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Dec 2011 08:22:24 -0500
Content-Disposition: inline
In-Reply-To: <CANtneHJWwcyYhq0U4p6_nc9nDRfpv0_mwGZm_DKr1pHd+urU4w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 14, 2011 at 11:29:42AM -0800, Pete Holland wrote:
> This is a great idea, thank you!  This is a problem I'm trying to
> solve right now and have found that using the rule counters is clunky
> and restrictive.  Specifically, this provides the kind of
> functionality that's needed to support changing the rule definitions
> without losing the accounting information.
> 
> Quick question, would this be limited to the filter table, or would we
> be able to use the target (or match as I saw suggested) in other
> tables?
> This would be most useful if it were available in the mangle (so we
> could mark+account in one spot... and if it were a match, in one rule)
> and nat tables (so we can account for traffic pre and post NAT
> treatment).

No restriction regarding what table you want to use this.

P.S: please, don't top-post, that's the nf-ml policy.
