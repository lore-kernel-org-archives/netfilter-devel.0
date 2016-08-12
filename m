From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: use_nf_conn_expires helper in more
 places
Date: Fri, 12 Aug 2016 12:25:17 +0200
Message-ID: <20160812102517.GB3086@salvia>
References: <1470185107-17332-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58994 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500AbcHLKZV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:25:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 470DFD1636
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:25:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 39935FF134
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:25:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 38C5C4C334
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:25:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470185107-17332-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 03, 2016 at 02:45:07AM +0200, Florian Westphal wrote:
> ... so we don't need to touch all of these places when we get rid of the
> timer in nf_conn.

Also applied, thanks.
