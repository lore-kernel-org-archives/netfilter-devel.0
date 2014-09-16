From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: Re: [PATCH v4 0/2] nfacct: add filter in to the list operation
Date: Tue, 16 Sep 2014 11:08:44 +0400
Message-ID: <5417E1FC.4070007@samsung.com>
References: <1410519418-8671-1-git-send-email-a.perevalov@samsung.com>
 <20140915164502.GA4705@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: alexey.perevalov@hotmail.com, netfilter-devel@vger.kernel.org,
	kyungmin.park@samsung.com, hs81.go@samsung.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64114 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaIPHIt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:08:49 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBZ00137FZHWX10@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Tue, 16 Sep 2014 08:11:41 +0100 (BST)
In-reply-to: <20140915164502.GA4705@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/15/2014 08:45 PM, Pablo Neira Ayuso wrote:
> On Fri, Sep 12, 2014 at 02:56:56PM +0400, Alexey Perevalov wrote:
>> Hello Pablo,
>>
>> It's fourth version of patch for filtering, but also with fix for argument
>> singleness.
> Applied, thanks Alexey.
>
> I have made also some mostly comestic changes on it:
>
> - Avoid line break at 80 chars in strncmp(). We can replace strncmp by
>    a new function that takes only two parameters, then avoid the line
>    break.
>
> - Removed NFACCT_F_QUOTAS, it's only used once. We can introduce this
>    later if we have more spots where we can use it.
>
> - Rename quota-bytes to bytes-quota and quota-packets to pkts-quota.
>    The reason for this is that nfacct allows shortened syntax, eg.
>
>    nfacct l r
>
> which is actually 'list reset'. By swapping the words, we can now use:
>
>    nfacct l r p
>
> which only resets packet-based quotas.
Thank you for collaboration,
btw, I know about command line shortened syntax, but it also allows 
following:
nfacct li res
instead of nfacct list reset,
and I was wonder bug it or not )

>


-- 
Best regards,
Alexey Perevalov
