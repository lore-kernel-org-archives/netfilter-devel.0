From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: conntrack: de-inline two helpers
Date: Tue, 12 Apr 2016 23:53:00 +0200
Message-ID: <20160412215300.GA20803@salvia>
References: <1460404356-29893-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59484 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933849AbcDLVxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:53:11 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E7FCE666E
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:53:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0F20E1B3065
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:53:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9E6961B3065
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:53:02 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460404356-29893-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 11, 2016 at 09:52:34PM +0200, Florian Westphal wrote:
> Noticed that we have two static inline functions that should be normal functions
> instead.
> First patch saves a bit text size as well.

Series applied, thanks.
