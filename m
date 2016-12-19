From: Phil Sutter <phil@nwl.cc>
Subject: Re: libmnl compile failure.
Date: Mon, 19 Dec 2016 09:49:21 +0100
Message-ID: <20161219084921.GV13857@orbyte.nwl.cc>
References: <1758bff0-40b1-a404-e225-eff504c6a1d7@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: maowenan <maowenan@huawei.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60536 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751255AbcLSItX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 03:49:23 -0500
Content-Disposition: inline
In-Reply-To: <1758bff0-40b1-a404-e225-eff504c6a1d7@huawei.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Fri, Dec 16, 2016 at 08:54:59AM +0800, maowenan wrote:
> There is something wrong when I make libmnl, could you please help check?

There is no error message in the output you pasted. Looks like you're
calling 'make' in an already built source tree, so nothing needs to be
done. Do you see the binaries in src/.libs?

Cheers, Phil
