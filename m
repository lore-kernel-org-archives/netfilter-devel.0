From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: SNAT before IPSEC - why?
Date: Sat, 8 Oct 2011 11:26:43 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1110081124330.2367@frira.zrqbmnf.qr>
References: <4E8FB084.6030807@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:47075 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380Ab1JHJ0p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Oct 2011 05:26:45 -0400
In-Reply-To: <4E8FB084.6030807@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-10-08 04:08, Stephen Clark wrote:

> Hi,
>
> What is the reasoning for having SNAT happen before ipsec encryption?

It can happen before and/or after - see the nf flow graph.

