From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH V2] NETFILTER: replace list_for_each with list_for_each_entry
Date: Wed, 14 Nov 2007 16:58:03 +0800
Message-ID: <473AB89B.70504@cn.fujitsu.com>
References: <473A6490.1000704@cn.fujitsu.com> <473A9A21.6030000@cn.fujitsu.com> <473AA156.9080600@cn.fujitsu.com> <473AB3CF.6010100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [222.73.24.84] ([222.73.24.84]:62216 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbXKNJAd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 04:00:33 -0500
In-Reply-To: <473AB3CF.6010100@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Li Zefan wrote:
>>  net/netfilter/nf_sockopt.c         |   13 ++++---------
> 
> And removed that part since you're the third person within two
> weeks to send an identical patch :) Please always base your
> patches on Linus' latest -git tree or Dave's networking tree
> for the next version once it opens.
> 
> 
> 

OK, I will. :)

