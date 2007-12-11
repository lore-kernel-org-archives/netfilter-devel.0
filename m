From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] xt_mark match rev 1
Date: Tue, 11 Dec 2007 11:25:48 +0100
Message-ID: <475E65AC.9080901@trash.net>
References: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbXLKKZu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 05:25:50 -0500
In-Reply-To: <Pine.LNX.4.64.0712070341010.1262@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Introduce the xt_mark match revision 1. It uses fixed types,
> with the goal of obsoleting revision 0 some day (uses nonfixed types).


I don't know. We already have all this compat crap because
we specifically don't want to obsolete old userspace binaries,
so the only benefit I see is a minor decrease in overhead
when loading rules.


