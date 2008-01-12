From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ulogd2: fix db OUTPUT system
Date: Sat, 12 Jan 2008 15:50:59 +0100
Message-ID: <4788D3D3.8080603@trash.net>
References: <1200090155.22717.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49472 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762430AbYALOzu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:55:50 -0500
In-Reply-To: <1200090155.22717.7.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hi,
> 
> The following patch fixes MySQL and Pgsql output modules.
> 
> The callback function was not correctly initialized and this was leading
> to a crash by calling the a NULL function. This patch correctly inits
> the callback.

Also applied, thanks.
