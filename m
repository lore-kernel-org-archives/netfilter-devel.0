From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] [CONNTRACK-TOOLS] conntrack: avoid error with expectations
 when using 'conntrack -E -e ALL ...'
Date: Thu, 08 Oct 2009 18:07:40 +0200
Message-ID: <4ACE0E4C.1080607@netfilter.org>
References: <20091007134512.6951.86395.stgit@lb64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hannes Eder <heder@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47893 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963AbZJHQI2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:08:28 -0400
In-Reply-To: <20091007134512.6951.86395.stgit@lb64>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hannes Eder wrote:
> Avoid this error:
> 
> conntrack v0.9.13 (conntrack-tools): Operation failed: No such file or directory
> 
> when using 'conntrack -E -e ALL ...'.
> 
> This is caused by the fact that netfilter expectations also get
> delivered, but things are not setup for this, nfnl_catch returns -1
> and errno = ENOENT.

Applied, thanks Hannes!
