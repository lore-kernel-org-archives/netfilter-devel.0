From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack
Date: Tue, 14 Feb 2012 20:54:29 +0100
Message-ID: <20120214195429.GD29165@1984>
References: <4F3A580A.2070105@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067Ab2BNTyb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:54:31 -0500
Content-Disposition: inline
In-Reply-To: <4F3A580A.2070105@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 14, 2012 at 07:48:10AM -0500, Stephen Clark wrote:
> Hi,
> 
> Does connection tracking keep any counters on number of packets/and
> or bytes that are
> associated with a connection? If so how does one access them?

echo 1 > /proc/sys/net/netfilter/nf_conntrack_acct

Then, you can access them via:

conntrack -L
