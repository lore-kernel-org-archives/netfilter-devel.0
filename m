From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: make comparision helpers stub
 functions in ZONES=n case
Date: Thu, 23 Jun 2016 19:38:12 +0200
Message-ID: <20160623173812.GB3515@salvia>
References: <1465592941-18252-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56441 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbcFWRiU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:38:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5D5008D051B
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4BD939EBA7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5E6199EBA7
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:38:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465592941-18252-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 10, 2016 at 11:09:01PM +0200, Florian Westphal wrote:
> Those comparisions are useless in case of ZONES=n; all conntracks
> will reside in the same zone by definition.

Also applied, thanks.
