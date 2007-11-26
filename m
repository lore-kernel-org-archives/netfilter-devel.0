From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF [PATCH 1/6] (borked it!) Use lowercase names for matches
Date: Tue, 27 Nov 2007 00:54:43 +0100
Message-ID: <474B5CC3.9090302@trash.net>
References: <Pine.LNX.4.64.0711270041320.22369@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0711270050260.22369@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641AbXKZXyt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:54:49 -0500
In-Reply-To: <Pine.LNX.4.64.0711270050260.22369@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Nov 27 2007 00:42, Jan Engelhardt wrote:
>   
>> @@ -63,17 +63,8 @@ config IP_NF_MATCH_IPRANGE
>>
>> 	  To compile it as a module, choose M here.  If unsure, say N.
>>
>> -config IP_NF_MATCH_TOS
>> -	tristate "TOS match support"
>> -	depends on IP_NF_IPTABLES
>> -	help
>> -	  TOS matching allows you to match packets based on the Type Of
>> -	  Service fields of the IP packet.
>> -
>> -	  To compile it as a module, choose M here.  If unsure, say N.
>> -
>>     
>
> (quilt or pebkac, that is the question.)
>   

I already fixed it, don't worry :)

