From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/5][IPTABLES]: Import netfilter.h
Date: Tue, 29 Jan 2008 14:10:55 +0100
Message-ID: <479F25DF.6080204@trash.net>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54591 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762014AbYA2N0x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:26:53 -0500
In-Reply-To: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Import netfilter.h from kernel to get hold of union nf_inet_addr
> and fix a compile error in current iptable tarball releases when
> used with non-development kernels.

We already have this exact file in the current sources, without
the #ifdef __KERNEL__ parts.
