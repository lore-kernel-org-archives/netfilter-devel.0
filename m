From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_ct_sctp: validate vtag for new conntrack
 entries
Date: Thu, 10 Dec 2015 13:02:33 +0100
Message-ID: <20151210120233.GA2084@salvia>
References: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-sctp@vger.kernel.org,
	Vlad Yasevich <vyasevich@gmail.com>,
	Neil Horman <nhorman@tuxdriver.com>, mkubecek@suse.cz
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39311 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbbLJMCk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 07:02:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D0C47B6B9C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:02:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C1BCFDA863
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:02:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B59C2DA87C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:02:32 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <85c8c8c570bdbf6f20f56fdef96d8017fea3cc4c.1449579256.git.marcelo.leitner@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Marcelo,

On Tue, Dec 08, 2015 at 11:11:10AM -0200, Marcelo Ricardo Leitner wrote:
> Commit d7ee35190427 ("netfilter: nf_ct_sctp: minimal multihoming
> support") allowed creating conntrack entries based on the heartbeat
> exchange, so that we can track secondary paths too.
> 
> This patch adds a vtag verification to that. That is, in order to allow
> a HEARTBEAT or a HEARTBEAT_ACK through, the tuple (src port, dst port,
> vtag) must be already known.

This infrastructure that you're adding in this patch looks very
similar to me to conntrack expectations.

Did you evaluate this possibility?

The idea would be to add the vtag to the tuples since it allows us to
uniquely identify the SCTP flow. Then, if you see the hearbeat, you
can register an expectation for the tuple (any-src-ip, any-dst-ip,
sctp, specific-sport, specific-dport, specific-vtag-value).

Then, any secondary STCP flow matching that expectation in the future
will be accepted as RELATED traffic.
