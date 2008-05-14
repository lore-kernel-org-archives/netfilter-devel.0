From: David Miller <davem@davemloft.net>
Subject: Re: Large packets received from the queue
Date: Wed, 14 May 2008 03:06:05 -0700 (PDT)
Message-ID: <20080514.030605.175448517.davem@davemloft.net>
References: <20080513.181548.155688952.davem@davemloft.net>
	<20080514084814.GA10392@khasse.inl.fr>
	<482AA8A0.5090604@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: eric@inl.fr, jameshough@bemac.com, netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751658AbYENKGL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 06:06:11 -0400
In-Reply-To: <482AA8A0.5090604@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Wed, 14 May 2008 10:53:52 +0200

> Actually we segment TSO frames before queuing because packet
> modifications broke TSO.

We fixed that, or at least I thought we did :)
