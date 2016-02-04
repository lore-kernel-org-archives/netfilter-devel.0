From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] meta: add prandom matching
Date: Thu, 04 Feb 2016 15:39:04 +0100
Message-ID: <DB5D81F9-A143-4DE6-A315-465B72EA84B3@trash.net>
References: <1454368741-16368-1-git-send-email-fw@strlen.de> <1454368741-16368-3-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47177 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756713AbcBDOjM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Feb 2016 09:39:12 -0500
In-Reply-To: <1454368741-16368-3-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 2. Februar 2016 00:19:00 MEZ, schrieb Florian Westphal <fw@strlen.de>:
>
> enum datatypes {
> 	TYPE_INVALID,
>@@ -78,6 +79,7 @@ enum datatypes {
> 	TYPE_ICMPV6_CODE,
> 	TYPE_ICMPX_CODE,
> 	TYPE_DEVGROUP,
>+	TYPE_PROBABILITY,
> 	__TYPE_MAX
> 

Any reason why you chose to add this type instead of a generic floating point type?

