From: Patrick McHardy <kaber@trash.net>
Subject: Re: 05/13 [NETFILTER]: xt_recent: make old proc interface configurable
Date: Mon, 14 Jul 2008 15:30:02 +0200
Message-ID: <487B54DA.6030100@trash.net>
References: <alpine.LNX.1.10.0807101522400.27323@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0807101525190.27323@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44835 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYGNNba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jul 2008 09:31:30 -0400
In-Reply-To: <alpine.LNX.1.10.0807101525190.27323@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit ffffffffffffffffffffffffffffffffffffffff
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Apr 9 15:43:58 2008 +0200
> 
> [NETFILTER]: xt_recent: make old proc interface configurable

Ah here it is :) This belongs in 04/13 IMO. And without the OLDPROC
define please, while CONFIG_NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
really is a bit long, the ifdefs still fit on one line nicely.
