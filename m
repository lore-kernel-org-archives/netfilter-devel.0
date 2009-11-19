From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 01/02: xt_osf: fix xt_osf_remove_callback() return
 value
Date: Thu, 19 Nov 2009 12:28:04 -0800 (PST)
Message-ID: <20091119.122804.241406687.davem@davemloft.net>
References: <20091119145902.18633.28666.sendpatchset@x2.localnet>
	<20091119145903.18633.79066.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51879
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755935AbZKSU1r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Nov 2009 15:27:47 -0500
In-Reply-To: <20091119145903.18633.79066.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 19 Nov 2009 15:59:03 +0100 (MET)

> commit 1c622ae67bfc729891f5cd80795b15b87e6ac471
> Author: Roel Kluin <roel.kluin@gmail.com>
> Date:   Fri Nov 13 09:31:35 2009 +0100
> 
>     netfilter: xt_osf: fix xt_osf_remove_callback() return value
>     
>     Return a negative error value.
>     
>     Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
