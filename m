From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 1/3] flex_array: fix the panic issue when calling
 flex_array_alloc() without __GFP_ZERO
Date: Fri, 9 Apr 2010 10:09:14 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1004091009030.22387@chino.kir.corp.google.com>
References: <4BBEA79A.3020307@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:47794 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0DIRJW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 13:09:22 -0400
In-Reply-To: <4BBEA79A.3020307@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 9 Apr 2010, Changli Gao wrote:

> fix the panic issue when calling flex_array_alloc() without __GFP_ZERO.
> 
> memset is called with the wrong address, then kernel panics.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Acked-by: David Rientjes <rientjes@google.com>
