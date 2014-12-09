From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/3] netlink_delinearize: fix listing of set members
 in host byteorder using integer_type
Date: Tue, 9 Dec 2014 07:53:21 +0000
Message-ID: <20141209075320.GA15583@acer.localdomain>
References: <1418077474-6431-1-git-send-email-pablo@netfilter.org>
 <1418077474-6431-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33305 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbaLIHxZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2014 02:53:25 -0500
Content-Disposition: inline
In-Reply-To: <1418077474-6431-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.12, Pablo Neira Ayuso wrote:
>  nft list table filter
>  ...
>         cpu { 50331648, 33554432, 0, 16777216} counter packets 8 bytes 344

I'm certain this used to work for mark values, so I'm wondering
what broke it. We might have a more fundamental bug somewhere.

