From: "james hough" <jameshough@bemac.com>
Subject: Re: Large packets received from the queue
Date: Wed, 14 May 2008 10:08:54 +0100
Message-ID: <008201c8b5a2$2254eea0$5c01a8c0@jimpc>
References: <001b01c8b4f8$bf9bb180$5c01a8c0@jimpc> <20080513.181548.155688952.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "David Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from omega-smtp.bemac.com ([194.193.56.2]:35827 "EHLO
	omega-real.bemac.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752538AbYENJIw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 05:08:52 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> These are TSO frames, and you must handle them.

This does appear to be the case, i have disabled TSO for the interface and i 
no longer get the large packets coming into my app.

thank you 


