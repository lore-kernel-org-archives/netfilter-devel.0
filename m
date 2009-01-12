From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:22:55 +0100
Message-ID: <496AE1BF.6050803@trash.net>
References: <496AD8C7.2020208@trash.net> <alpine.LSU.2.00.0901120710590.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56687 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbZALGW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:22:57 -0500
In-Reply-To: <alpine.LSU.2.00.0901120710590.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> build: remove non-portable rule
> 
>> Makefile.am:97: `%'-style pattern rules are a GNU make extension
> 
> (iptables still requires GNU make for extensions/, because it is
> so much easier to write.)
> 

Also applied, thanks.

