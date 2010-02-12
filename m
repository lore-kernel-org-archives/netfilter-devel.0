From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: don't use INIT_RCU_HEAD()
Date: Fri, 12 Feb 2010 06:26:17 +0100
Message-ID: <4B74E679.3060705@trash.net>
References: <20100211194911.GA9756@x200> <20100211224651.GF6759@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org
To: paulmck@linux.vnet.ibm.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56853 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab0BLF0T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 00:26:19 -0500
In-Reply-To: <20100211224651.GF6759@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Paul E. McKenney wrote:
> On Thu, Feb 11, 2010 at 09:49:11PM +0200, Alexey Dobriyan wrote:
>> call_rcu() will unconditionally reinitialize RCU head anyway.
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
>> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Applied, thanks.
