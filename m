From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 2/4] xt_TEE
Date: Sun, 25 Nov 2007 20:55:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711252054370.9477@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252030520.13641@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sebastian Classen <sebastian.classen@freenet.de>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46440 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755067AbXKYTzS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 14:55:18 -0500
In-Reply-To: <Pine.LNX.4.64.0711252030520.13641@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 25 2007 20:39, Krzysztof Oledzki wrote:
> On Sun, 25 Nov 2007, Jan Engelhardt wrote:
>> Netfilter: Import xt_TEE
>>
>>
>> Originally from Sebastian Classen.
>> xt_TEE is the logical successor to ipt_ROUTE; routing based on packet
>> charactersitics is done using xt_MARK/iproute2/fwmark nowadays, so
>> what remains of ipt_ROUTE is the --tee option, which xt_TEE implements.
>
> IMHO it is not successor as it does not provide all ipt_ROUTE functionality. As
> I appreciate your work and time spent on cleaning this code I think it would be
> better not to strip it as xt_MARK/iproute2/fwmark is not always a valid option.

We've been there -
http://www.gossamer-threads.com/lists/engine?do=post_view_printable;post=68316;list=iptables
