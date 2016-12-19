From: maowenan <maowenan@huawei.com>
Subject: RE: libmnl compile failure.
Date: Mon, 19 Dec 2016 08:55:48 +0000
Message-ID: <F95AC9340317A84688A5F0DF0246F3F20151D905@szxeml504-mbs.china.huawei.com>
References: <1758bff0-40b1-a404-e225-eff504c6a1d7@huawei.com>
 <20161219084921.GV13857@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:12662 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754655AbcLSI4I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 03:56:08 -0500
In-Reply-To: <20161219084921.GV13857@orbyte.nwl.cc>
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

no, I don't see src.libs, but I have built nft success now, there is nothing need to do when make libmnl.
The libmnl and libnftnl have existed in my system.
Thank you very much.
     

> -----Original Message-----
> From: Phil Sutter [mailto:phil@nwl.cc]
> Sent: Monday, December 19, 2016 4:49 PM
> To: maowenan
> Cc: netfilter-devel@vger.kernel.org
> Subject: Re: libmnl compile failure.
> 
> Hi,
> 
> On Fri, Dec 16, 2016 at 08:54:59AM +0800, maowenan wrote:
> > There is something wrong when I make libmnl, could you please help check?
> 
> There is no error message in the output you pasted. Looks like you're calling
> 'make' in an already built source tree, so nothing needs to be done. Do you see
> the binaries in src/.libs?
> 
> Cheers, Phil
