From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] src: Buffer is null terminated.
Date: Wed, 27 Sep 2017 14:07:38 +0200
Message-ID: <20170927120738.GB13535@salvia>
References: <20170920162309.5852-1-rvarsha016@gmail.com>
 <20170920162309.5852-2-rvarsha016@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Varsha Rao <rvarsha016@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:35452 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751287AbdI0MHm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 08:07:42 -0400
Content-Disposition: inline
In-Reply-To: <20170920162309.5852-2-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 20, 2017 at 09:53:09PM +0530, Varsha Rao wrote:
> In _snprintf() functions definition the buffer is null terminated.

Also applied, thanks.
