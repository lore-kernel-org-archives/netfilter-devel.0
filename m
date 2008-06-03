From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] iptables version defines
Date: Tue, 03 Jun 2008 15:02:37 +0200
Message-ID: <484540ED.3050805@trash.net>
References: <200806021549.15005.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0806021646350.4055@fbirervta.pbzchgretzou.qr> <200806021732.57124.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39596 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687AbYFCNCk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:02:40 -0400
In-Reply-To: <200806021732.57124.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch wrote:
> I'm alright with your proposed change to XTABLES_API_VERSION
> and the drop of _MAJOR, _MINOR and _PATCH macros as
> one can easily check for same thing via "xyz < XTABLES_API_VERSION(2,6,0)"
> 
> Attached is an updated patch.

Applied and pushed out, thanks.
