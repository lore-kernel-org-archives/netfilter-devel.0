From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH resend] netfilter: don't always initialize ct->proto
Date: Fri, 12 Nov 2010 17:33:56 +0100
Message-ID: <4CDD6C74.7050100@trash.net>
References: <1289577014-6152-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36119 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab0KLQeE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:34:04 -0500
In-Reply-To: <1289577014-6152-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 12.11.2010 16:50, schrieb Changli Gao:
> ct->proto is big(60 bytes) due to structure ip_ct_tcp, and we don't need
> to initialize the whole for all the other protocols. This patch moves
> proto to the end of structure nf_conn, and pushes the initialization down
> to the individual protocols.
> 

Applied, thanks Changli.
