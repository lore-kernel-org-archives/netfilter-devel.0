From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next-2.6] conntrack: one less atomic op in nf_ct_expect_insert()
Date: Tue, 16 Nov 2010 10:19:54 +0100
Message-ID: <4CE24CBA.9020105@trash.net>
References: <1289861877.3364.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab0KPJUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:20:00 -0500
In-Reply-To: <1289861877.3364.22.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15.11.2010 23:57, Eric Dumazet wrote:
> Instead of doing atomic_inc(&exp->use) twice,
> call atomic_add(2, &exp->use);

Applied, thanks Eric.
