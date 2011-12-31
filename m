From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
 match user space
Date: Sat, 31 Dec 2011 16:45:18 +0100
Message-ID: <20111231154518.GA17114@1984>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
 <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
 <20111230114339.GA15916@lutz.bln.innominate.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ljaenicke@innominate.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55121 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1LaPpV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 10:45:21 -0500
Content-Disposition: inline
In-Reply-To: <20111230114339.GA15916@lutz.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2011 at 12:43:39PM +0100, Lutz Jaenicke wrote:
> Against which tree do I have to re-submit this patch to get it merged?

You kidding me ;-), this was discussed more than one year ago.

http://markmail.org/message/afhn66qzyebyf7cs#query:+page:1+mid:s3ji4qj74vkovbxi+state:results

The fix was agreed to be done in user-space.

I have pushed the following patch for libnetfilter_conntrack:

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_conntrack.git;a=commitdiff;h=187c8099704d4616de9479104ba6560c03f90c39;hp=3c5b8711a83caad7d6e4525a823002cac0f593a4

Please, confirm that it fixes the problem.

Thank you.
