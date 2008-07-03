From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Minor bugfix
Date: Thu, 03 Jul 2008 20:30:03 +0200
Message-ID: <486D1AAB.7040501@trash.net>
References: <1215028516.9467.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: jdb@comx.dk
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45010 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbYGCSaE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jul 2008 14:30:04 -0400
In-Reply-To: <1215028516.9467.2.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> Minor bugfix, an extra check is needed if the tail element is a
> builtin chain, as builtin chains are not sorted.

Applied, thanks.
