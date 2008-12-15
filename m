From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [PATCH] netfilter: remove padding from struct
 xt_match on 64bit	builds
Date: Mon, 15 Dec 2008 14:10:39 +0100
Message-ID: <4946574F.5080107@trash.net>
References: <1229089190.2921.7.camel@castor.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, netfilter@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYLONKr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2008 08:10:47 -0500
In-Reply-To: <1229089190.2921.7.camel@castor.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Kennedy wrote:
> reorder struct xt_match to remove 8 bytes of padding and make its size
> 128 bytes.
> 
> This saves a small amount of data space in each of the xt netfilter
> modules and fits xt_match in one 128 byte cache line.

Applied, thanks.
