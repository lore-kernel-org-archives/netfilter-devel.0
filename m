From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: don't always initialize ct->proto
Date: Mon, 25 Oct 2010 17:43:06 +0200
Message-ID: <4CC5A58A.8070204@trash.net>
References: <1287888016-25213-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48210 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab0JYPnH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:43:07 -0400
In-Reply-To: <1287888016-25213-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 24.10.2010 04:40, schrieb Changli Gao:
> ct->proto is big(60 bytes) due to structure ip_ct_tcp, and we don't need
> to initialize the whole for all the other protocols. This patch moves
> proto to the end of structure nf_conn, and pushes the initialization down
> to the individual protocols.

Looks fine to me. Please resend once net-next is open again. Thanks!
