From: Patrick McHardy <kaber@trash.net>
Subject: Re: can expectations be marked persistent, so they can match repeatedly
 until they timeout?
Date: Mon, 28 Mar 2011 13:27:38 +0200
Message-ID: <4D9070AA.60100@trash.net>
References: <AANLkTi=dEfb8f1moPE5Mp2yS5DqiB=abuJcFP99opXy9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40081 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab1C1L2H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 07:28:07 -0400
In-Reply-To: <AANLkTi=dEfb8f1moPE5Mp2yS5DqiB=abuJcFP99opXy9@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.03.2011 18:43, Sam Roberts wrote:
> I'm writing a userspace conntrack, using nfqueue and conntrack.
> 
> Creating expectations works fine, metfilter matches and allows the
> expected connection.
> 
> However, unlike ftp, the negotiated ephemeral port is used by multiple
> simultaneous tcp connections for some period. I'd like the expectation
> to be kept in place until it times out, even when its matched.
> 
> I can create this effect by watching for the conntrack event
> indicating the expectation was destroyed, and recreating it, but I'd
> like to know if there is a better way.

You should be able to use NF_CT_EXPECT_PERMANENT.
