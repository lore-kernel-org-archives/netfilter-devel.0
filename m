From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_nat_core: fix memset size error
Date: Tue, 06 Nov 2007 01:13:15 +0100
Message-ID: <472FB19B.3090008@trash.net>
References: <472E7623.1030707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47934 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXKFANc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:13:32 -0500
In-Reply-To: <472E7623.1030707@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Li Zefan wrote:
> Hi,
>
> The size passing to memset is the size of a pointer.
>
> Signed-off-by Li Zefan <lizf@cn.fujitsu.com>
>   

Applied, thanks Li.

