From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Consistent and unique symbol names
Date: Thu, 15 Nov 2007 13:22:29 +0100
Message-ID: <473C3A05.9010708@trash.net>
References: <Pine.LNX.4.64.0711141152040.24744@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43038 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520AbXKOMW4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2007 07:22:56 -0500
In-Reply-To: <Pine.LNX.4.64.0711141152040.24744@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> Give all Netfilter modules consistent and unique symbol names.
> 

I fixed a compilation error in the xt_mark CONFIG_COMPAT case
and applied it, thanks Jan.
