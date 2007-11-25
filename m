From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] iptables: always print mask in iptables-save
Date: Sun, 25 Nov 2007 16:19:16 +0100
Message-ID: <47499274.5030604@trash.net>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711250206250.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61744 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbXKYPTx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:19:53 -0500
In-Reply-To: <Pine.LNX.4.64.0711250206250.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> iptables prints the mask as a prefix length if it is valid;
> This patch makes iptables-save do the same.
> 
> Also, iptables-save will always print "/32" in the "-s addr/32"
> case now. This reduces the amount of code external parsing scripts
> need to provide to properly parse iptables-save output.
> 
> ip6tables-save already does the right thing, so no change there.


Applied.
