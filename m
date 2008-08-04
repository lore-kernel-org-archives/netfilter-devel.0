From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: src: remove dependency on libiptc headers
Date: Mon, 04 Aug 2008 16:35:35 +0200
Message-ID: <489713B7.10909@netfilter.org>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr> <489444E1.8060303@netfilter.org> <48944A98.8050202@netfilter.org> <alpine.LNX.1.10.0808021220320.12119@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38774 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756748AbYHEAHg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:07:36 -0400
In-Reply-To: <alpine.LNX.1.10.0808021220320.12119@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2008-08-02 07:52, Pablo Neira Ayuso wrote:
>>>>  
> #define XTABLES_VERSION "@PACKAGE_VERSION@"                                     
>>>>  #define XTABLES_API_VERSION(x,y,z)    (0x10000*(x) + 0x100*(y) + z)
>>>>  
>>>> -	xt_chainlabel name;
>>>> +	const char *name;
>>>>  
>>> This is breaking the ABI. You're replacing at field of 32 bytes by one
>>> of 4 bytes.
> 
> The API actually remains the same, due to the nature of char[]
> decaying into char* (and .name is also only used in the registrator);
> the ABI (indicated by XTABLES_VERSION) changes yes, and that is fine
> because we moved from 1.4.1 to 1.4.2-rc1.

Sure, but say that someone uses whatever iproute2 version <=
iproute2-2.6.26 - which does not check for any ABI version numbering
AFAICS - and then it compiles whatever >= 1.4.2-rc1 by hand, then
jamal's ipt thing will not work as they use different ABIs.

I'm not talking on how to solve future interdependecy problems - which
you seems to have it done by exporting xtables as library - but the
problems that the size change of .name will trigger for some time.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
