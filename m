From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/03]: nf_nat: fix memset error
Date: Tue, 13 Nov 2007 02:57:36 -0800 (PST)
Message-ID: <20071113.025736.255576150.davem@davemloft.net>
References: <20071113105500.25336.39074.sendpatchset@localhost.localdomain>
	<20071113105501.25336.58654.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53803
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753217AbXKMK5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:57:37 -0500
In-Reply-To: <20071113105501.25336.58654.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 13 Nov 2007 11:55:41 +0100 (MET)

> [NETFILTER]: nf_nat: fix memset error
> 
> The size passing to memset is the size of a pointer.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
