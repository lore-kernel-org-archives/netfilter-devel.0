From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [nft PATCH] src: check if the set name is too long
Date: Fri, 21 Mar 2014 09:24:47 +0200
Message-ID: <532BE93F.6010400@linux.intel.com>
References: <1395332403-3823-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Giuseppe Longo <giuseppelng@gmail.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7818 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbaCUHYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Mar 2014 03:24:50 -0400
In-Reply-To: <1395332403-3823-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> checks if the name of set is larger than 15 chars

You mean 16 characters

Btw, have you tested 16 chars length name: when listing the set back,
is such name cut to 15 chars?

That sounds to be an issue from kernel side, at least looking quickly,
I could not find any code shortening this in  libmnl, libnftnl or nftables.

Tomasz
