From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: avoid additional compare.
Date: Wed, 04 Nov 2009 13:14:07 +0100
Message-ID: <4AF1700F.1090401@trash.net>
References: <4AEF9D99.5070804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: xiaosuo@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36826 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755345AbZKDMOG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:14:06 -0500
In-Reply-To: <4AEF9D99.5070804@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changli Gao wrote:
> avoid additional compare.
> 
> avoid additional compare.

This doesn't even compile:

net/netfilter/nf_conntrack_core.c: In function 'early_drop':
net/netfilter/nf_conntrack_core.c:522: error: 'NF_CT_EVICITON_RANGE'
undeclared (first use in this function)

Please don't send me untested patches.
