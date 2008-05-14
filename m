From: Eric Leblond <eric@inl.fr>
Subject: Re: Large packets received from the queue
Date: Wed, 14 May 2008 10:48:14 +0200
Message-ID: <20080514084814.GA10392@khasse.inl.fr>
References: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc> <20080513.181548.155688952.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jameshough@bemac.com, netfilter-devel@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:57636 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbYENIsW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 04:48:22 -0400
Content-Disposition: inline
In-Reply-To: <20080513.181548.155688952.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tuesday, 2008 May 13 at 18:15:48 -0700, David Miller wrote:
> From: "james hough" <jameshough@bemac.com>
> Date: Tue, 13 May 2008 13:56:23 +0100
> 
> > the problem I have is that my app is receiving larger than MTU packets off 
> > the queue, often in excess of 2000bytes. The MTU is set to 1500 and the 
> > problem only seems to occur on outbound traffic when doing file uploads. in 
> > this case I am doing an FTP put.
> 
> These are TSO frames, and you must handle them.

Or maybe just loopback packet and as default loopback MTU is 16436 ;)

BR,
-- 
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
