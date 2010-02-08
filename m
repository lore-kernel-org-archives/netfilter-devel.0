From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next] netfilter: fix build failure with CONNTRACK=y
 NAT=n
Date: Mon, 08 Feb 2010 15:39:57 +0100
Message-ID: <4B70223D.70701@trash.net>
References: <1265626669-24689-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36000 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643Ab0BHOkA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Feb 2010 09:40:00 -0500
In-Reply-To: <1265626669-24689-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> net/ipv4/netfilter/nf_defrag_ipv4.c: In function 'ipv4_conntrack_defrag':
> net/ipv4/netfilter/nf_defrag_ipv4.c:62: error: implicit declaration of function 'nf_ct_is_template'

Applied, thanks Florian.
