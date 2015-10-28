From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: add missing NULL pointer check
Date: Wed, 28 Oct 2015 03:44:39 +0100
Message-ID: <20151028024439.GA3222@salvia>
References: <1445911852-4838-1-git-send-email-kamatam@amazon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, msw@amazon.com,
	aliguori@amazon.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
	davem@davemloft.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: Munehisa Kamata <kamatam@amazon.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49019 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbbJ1Che (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2015 22:37:34 -0400
Content-Disposition: inline
In-Reply-To: <1445911852-4838-1-git-send-email-kamatam@amazon.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 26, 2015 at 07:10:52PM -0700, Munehisa Kamata wrote:
> Commit 8b13eddfdf04cbfa561725cfc42d6868fe896f56 ("netfilter: refactor NAT
> redirect IPv4 to use it from nf_tables") has introduced a trivial logic
> change which can result in the following crash.

This seems to have accidentally slipped through while adding redirect
support for nf_tables.

Applied, thanks.
