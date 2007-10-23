From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_sockopts list head cleanup
Date: Tue, 23 Oct 2007 14:39:12 +0200
Message-ID: <471DEB70.8060805@trash.net>
References: <20071022121905.GC6271@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44479 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXJWMkJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Oct 2007 08:40:09 -0400
In-Reply-To: <20071022121905.GC6271@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Alexey Dobriyan wrote:
> Code is using knowledge that nf_sockopt_ops::list list_head is first
> field in structure by using casts. Switch to list_for_each_entry()
> itetators while I am at it.
>
>   

Applied with a minor warning fix in the compat path, thanks Alexey.


