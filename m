From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables  1.4.8
Date: Fri, 21 May 2010 12:42:35 +0200
Message-ID: <4BF6639B.30401@trash.net>
References: <4BF5B639.6020309@unob.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ladislav Hagara <ladislav.hagara@unob.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37566 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab0EUKmh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 May 2010 06:42:37 -0400
In-Reply-To: <4BF5B639.6020309@unob.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ladislav Hagara wrote:
> Hi,
> I just installed new iptables 1.4.8 and seems it pretends it is only 1.4.7.
> 
> $ iptables --version
> iptables v1.4.7
> 
> Files in /usr/lib/pkgconfig also contains 1.4.7.

Oops crap, I thought my release script would commit the version
change. I'll fix it up.
