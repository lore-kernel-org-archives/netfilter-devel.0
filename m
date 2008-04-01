From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Account for IPv4 options in xt_TCPMSS
Date: Tue, 01 Apr 2008 14:55:32 +0200
Message-ID: <47F230C4.3030401@trash.net>
References: <alpine.LNX.1.10.0803291652171.28605@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61325 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYDAMzg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2008 08:55:36 -0400
In-Reply-To: <alpine.LNX.1.10.0803291652171.28605@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> 
> I am not exactly sure why 'minlen' only needed to be 40 bytes
> sizeof(iph)+tcphdr; does not the IP header must fit entirely
> into the MTU?


No, the sender is responsible for taking option sizes into
account.
