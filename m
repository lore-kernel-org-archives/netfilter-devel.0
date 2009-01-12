From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -git automake warnings
Date: Mon, 12 Jan 2009 07:22:08 +0100
Message-ID: <496AE190.6050604@trash.net>
References: <496AD8C7.2020208@trash.net> <496AD922.7050909@trash.net> <alpine.LSU.2.00.0901120709540.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56682 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZALGWJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 01:22:09 -0500
In-Reply-To: <alpine.LSU.2.00.0901120709540.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> build: use regular = assignments in Makefile
> 
> Resolves warnings:
> Makefile.am:7: `:='-style assignments are not portable
> Makefile.am:71: `:='-style assignments are not portable
> etc.
> 
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

Applies, thanks Jan.
