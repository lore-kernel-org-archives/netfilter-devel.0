From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] NETFILTER: replace list_for_each with list_for_each_entry
Date: Wed, 14 Nov 2007 14:48:01 +0800
Message-ID: <473A9A21.6030000@cn.fujitsu.com>
References: <473A6490.1000704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:53572 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbXKNGuh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 01:50:37 -0500
In-Reply-To: <473A6490.1000704@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Li Zefan wrote:
> Replace list_for_each with list_for_each_entry when possible.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> ---
>  net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 ++----
>  net/netfilter/nf_sockopt.c         |    8 ++------
>  2 files changed, 4 insertions(+), 10 deletions(-)
> 

Please ignore this patch, I'll send a new one.

Li Zefan

