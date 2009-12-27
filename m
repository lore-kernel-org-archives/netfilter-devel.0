From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doxygen.cfg.in: Make the file Work with doxygen 1.6.1
Date: Sun, 27 Dec 2009 16:04:38 +0100
Message-ID: <4B377786.7070200@netfilter.org>
References: <200912270653.09352.zecke@selfish.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Holger Freyther <zecke@selfish.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56746 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZL0PEY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:04:24 -0500
In-Reply-To: <200912270653.09352.zecke@selfish.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Holger Freyther wrote:
> Hi,
> 
> this is slighly more useful than the previous attempt. doxygen version 1.6.1 
> (as of Ubuntu Karmic) will refuse to generate the documentation as the 
> referenced header.html does not exist. This file was never in the repository 
> and emptying that option makes it work for 1.6 and keeps working for 1.5.6 
> (this version is included in Debian Lenny).

Applied, thanks Holger.
