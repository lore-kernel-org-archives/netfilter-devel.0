From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] utils: add test for nfq_get_uid and nfq_get_gid
Date: Wed, 8 Jan 2014 00:43:19 +0100
Message-ID: <20140107234319.GB17986@localhost>
References: <20131221113804.GA17964@localhost>
 <1389101420-16557-1-git-send-email-valentina.giusti@bmw-carit.de>
 <1389101420-16557-3-git-send-email-valentina.giusti@bmw-carit.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	fw@strlen.de, daniel.wagner@bmw-carit.de
To: valentina.giusti@bmw-carit.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754136AbaAGXnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 18:43:23 -0500
Content-Disposition: inline
In-Reply-To: <1389101420-16557-3-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Applied, but mangled the error message to avoid confusing users in
case they use an old kernel.
