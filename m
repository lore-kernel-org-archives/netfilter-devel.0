From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH */13] That sums it up
Date: Thu, 4 Oct 2007 12:18:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041216550.7253@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710041209210.7253@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710041214030.7253@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37147 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757334AbXJDKSE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 06:18:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id BA2CB1CD350DE
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Oct 2007 12:18:03 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710041214030.7253@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 4 2007 12:14, Jan Engelhardt wrote:
>Of course this series has 13, and not 14 patches, and it's
>unique symbols, not unique name.
>Need. More. Coke.

And it goes on top of r7051, so an extra `svn merge -r7052:7051 
libipt_addrtype.c` is needed right before patch 9/13.
