From: Patrick McHardy <kaber@trash.net>
Subject: Re: MARK extension
Date: Mon, 08 Mar 2010 17:18:15 +0100
Message-ID: <4B952347.6090502@trash.net>
References: <4B95210F.5020305@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49876 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab0CHQSV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Mar 2010 11:18:21 -0500
In-Reply-To: <4B95210F.5020305@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Woerner wrote:
> Hello,
> 
> according to the man page MARK "can only be used in the mangle table".
> But this is not correct. It is possible to use it also in the nat table.
> 
> Is this a documentation problem?

It seems that way. It probably should state "MARK can only be used
for output routing in the mangle table".
