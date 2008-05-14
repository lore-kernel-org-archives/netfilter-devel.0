From: David Miller <davem@davemloft.net>
Subject: Re: Large packets received from the queue
Date: Tue, 13 May 2008 18:15:48 -0700 (PDT)
Message-ID: <20080513.181548.155688952.davem@davemloft.net>
References: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: jameshough@bemac.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57292
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758177AbYENBPx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 21:15:53 -0400
In-Reply-To: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "james hough" <jameshough@bemac.com>
Date: Tue, 13 May 2008 13:56:23 +0100

> the problem I have is that my app is receiving larger than MTU packets off 
> the queue, often in excess of 2000bytes. The MTU is set to 1500 and the 
> problem only seems to occur on outbound traffic when doing file uploads. in 
> this case I am doing an FTP put.

These are TSO frames, and you must handle them.
