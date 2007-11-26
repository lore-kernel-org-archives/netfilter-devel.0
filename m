From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Mon, 26 Nov 2007 08:24:53 +0100
Message-ID: <474A74C5.8050609@trash.net>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47682 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbXKZHZj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 02:25:39 -0500
In-Reply-To: <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Netfilter: Import xt_TCPOPTSTRIP
> 
> 
> Originally from Sven Schnelle.
> xt_TCPOPTSTRIP can strip TCP options from TCP packets, for example,
> to disable Selective ACK or Window scaling.


I already have this queued. Will push upstream soon so you
can work against the current tree.
