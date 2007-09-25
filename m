From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipq thread safety
Date: Tue, 25 Sep 2007 16:31:08 +0200
Message-ID: <46F91BAC.8010304@trash.net>
References: <9b2db90b0709250656g304194b7va67d4a02eb23e26e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Nir Tzachar <nir.tzachar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36428 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbXIYOkg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:40:36 -0400
In-Reply-To: <9b2db90b0709250656g304194b7va67d4a02eb23e26e@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Nir Tzachar wrote:
> Hello.
> 
> I am writing an application which uses the QUEUE target and am using
> the libipq library.
> 
> I have a question regarding the thread safety of the library: is it
> possible to do an ipq_read from one thread and an ipq_set_verdict from another?
> Searching the archive of both netfilter and netfilter-devel yields no
> definite answers...


It should be. But I'd use nfnetlink_queue, which obsoletes ip_queue.
