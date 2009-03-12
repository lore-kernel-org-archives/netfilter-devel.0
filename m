From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Allow dropping packet after call to l4proto->packet
Date: Thu, 12 Mar 2009 18:26:27 +0100
Message-ID: <49B945C3.4000904@netfilter.org>
References: <200903121603.02733.christoph.paasch@gmail.com> <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41724 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753135AbZCLR0k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 13:26:40 -0400
In-Reply-To: <1236870826-10054-1-git-send-email-christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph Paasch wrote:
> As NF_DROP = 0, no packets would ever have been dropped.

Good catch. I'll also change -NF_DROP by NF_DROP in
nf_conntrack_proto_tcp.c. No need to resend the patch. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
