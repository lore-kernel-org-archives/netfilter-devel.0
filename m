From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [NETFILTER]: xt_recent: IPv6 support
Date: Wed, 09 Apr 2008 15:30:55 +0200
Message-ID: <47FCC50F.2020802@trash.net>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <e6fb8173fde4f1ea0cee785b763a2b2b37a89ebb.1207668694.git.jengelh@computergmbh.de> <47FCBB15.90003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46475 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYDINa5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:30:57 -0400
In-Reply-To: <47FCBB15.90003@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> This updates xt_recent to support the IPv6 address family.
>> The new /proc/net/xt_recent directory must be used for this.
>>
> Could you introduce a new option for this please? Something
> like CONFIG_NF_CONNTRACK_PROC_COMPAT.


BTW, it would be great if you could send me this patch before
anything else since my tree has grown too much and I intend
to push the first batch to Dave later and would like to already
include the hashlimit patch in this batch.

