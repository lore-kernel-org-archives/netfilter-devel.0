From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH V2] NETFILTER: replace list_for_each with list_for_each_entry
Date: Wed, 14 Nov 2007 09:37:35 +0100
Message-ID: <473AB3CF.6010100@trash.net>
References: <473A6490.1000704@cn.fujitsu.com> <473A9A21.6030000@cn.fujitsu.com> <473AA156.9080600@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37419 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXKNIhq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 03:37:46 -0500
In-Reply-To: <473AA156.9080600@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Li Zefan wrote:
> This patch replaces list_for_each with list_for_each_entry, and
> consequently fixes a bug too.
> 
> Things like this is wrong:
> 
> 	list_for_each(i, &nf_sockopts) {
> 		struct nf_sockopt_ops *ops = (struct nf_sockopt_ops *)i;
> 
> It makes the assumption that list is the first member of struct
> nf_sockopt_ops, so the ptr casting works. But if one day the structure
> changes, for example, like this:

So far its not a bug, so I've applied it without that description.
Thanks.

>  net/netfilter/nf_sockopt.c         |   13 ++++---------

And removed that part since you're the third person within two
weeks to send an identical patch :) Please always base your
patches on Linus' latest -git tree or Dave's networking tree
for the next version once it opens.

