From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: src: remove dependency on libiptc headers
Date: Sat, 2 Aug 2008 12:24:14 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808021220320.12119@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr> <489444E1.8060303@netfilter.org> <48944A98.8050202@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34875 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbYHBQYQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:24:16 -0400
In-Reply-To: <48944A98.8050202@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-08-02 07:52, Pablo Neira Ayuso wrote:
>>>  
#define XTABLES_VERSION "@PACKAGE_VERSION@"                                     
>>>  #define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
>>>  
>>> -	xt_chainlabel name;
>>> +	const char *name;
>>>  
>> This is breaking the ABI. You're replacing at field of 32 bytes by one
>> of 4 bytes.

The API actually remains the same, due to the nature of char[]
decaying into char* (and .name is also only used in the registrator);
the ABI (indicated by XTABLES_VERSION) changes yes, and that is fine
because we moved from 1.4.1 to 1.4.2-rc1.
