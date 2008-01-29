From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/5][IPTABLES]: Build adjustments
Date: Tue, 29 Jan 2008 14:16:38 +0100
Message-ID: <479F2736.6010405@trash.net>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801242002000.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54722 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217AbYA2Nch (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:32:37 -0500
In-Reply-To: <Pine.LNX.4.64.0801242002000.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> A few build system changes.
> 	* ip6tables needs IP6T_LIB_DIR
> 	* correctly trigger rebuild of master manpages when
> 	  submanpages have been touched

Applied.
