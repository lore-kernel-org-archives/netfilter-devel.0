From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] ctnetlink: optional reliable conntrack event delivery
Date: Mon, 30 Mar 2009 15:32:40 +0200
Message-ID: <49D0C9F8.2030005@netfilter.org>
References: <20090330132330.14337.4705.stgit@Decadence> <20090330132840.14337.57303.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48943 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754218AbZC3Nc4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Mar 2009 09:32:56 -0400
In-Reply-To: <20090330132840.14337.57303.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch does not include the removal of the notify chain as
> Patrick suggested yet, but I'll work on such change on top of this
> patch if this is OK.
  ^^^
BTW, this is comment is obsolte. I wrote it and then go back to add the
notify chain removal as the very first patch :).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
