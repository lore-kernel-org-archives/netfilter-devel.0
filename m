From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5][IPTABLES]: Give preference to iptables header files
Date: Tue, 29 Jan 2008 14:15:22 +0100
Message-ID: <479F26EA.7000308@trash.net>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801242001410.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54699 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932538AbYA2NbW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:31:22 -0500
In-Reply-To: <Pine.LNX.4.64.0801242001410.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Have the header files in the iptables source tree take precedence
> over those from the kernel source. Otherwise, building the current
> iptables from subversion just fails with kernels < 2.6.25.

Applied, thanks.
