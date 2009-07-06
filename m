From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: hashlimit supports only up to 10.000 pps
Date: Mon, 6 Jul 2009 13:12:57 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907061307130.6981@fbirervta.pbzchgretzou.qr>
References: <1246873993.8053.9.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46548 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbZGFLM4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:12:56 -0400
In-Reply-To: <1246873993.8053.9.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-07-06 11:53, Thomas Jacob wrote:

>Since hashlimit has come up on the list today:
>
>Is there any technical reason why hashlimit has a built in maximum
>limit of only 10k pps?

Same reason as xt_limit, see comment above MAX_CPJ.

>If not, are there any plans of some of the core
>developers to increase that limit in the near future? If not, I presume
>that patches would be welcome?

The rate estimator seems to be a better fit algorithmatically, though 
the extension lacks the grouping using --hashlimit-mode and 
--hashlimit-{src,dst}mask that makes hashlimit so versatile.
RATEEST also - standalone - requires two rules at this time.
