From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/29] [NETFILTER]: Use unsigned types for hooknum and
 pf vars
Date: Wed, 26 Mar 2008 21:32:30 +0100
Message-ID: <47EAB2DE.2070902@trash.net>
References: <alpine.LNX.1.10.0803251914060.2240@fbirervta.pbzchgretzou.qr> <af437bf3afbf0130adde82eb5810b66f2fa52c37.1206469820.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40499 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757147AbYCZUcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2008 16:32:32 -0400
In-Reply-To: <af437bf3afbf0130adde82eb5810b66f2fa52c37.1206469820.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Using u16 or something similar sizes would have made more sense
for the families, but it removes some inconstencies, so I've
applied it.
