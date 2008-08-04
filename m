From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: src: remove dependency on libiptc headers
Date: Mon, 4 Aug 2008 19:44:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808041943350.29809@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808010903020.31124@fbirervta.pbzchgretzou.qr> <489444E1.8060303@netfilter.org> <48944A98.8050202@netfilter.org> <alpine.LNX.1.10.0808021220320.12119@fbirervta.pbzchgretzou.qr> <489713B7.10909@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58135 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYHDXof (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 19:44:35 -0400
In-Reply-To: <489713B7.10909@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-08-04 10:35, Pablo Neira Ayuso wrote:
>> 
>> The API actually remains the same, due to the nature of char[]
>> decaying into char* (and .name is also only used in the registrator);
>> the ABI (indicated by XTABLES_VERSION) changes yes, and that is fine
>> because we moved from 1.4.1 to 1.4.2-rc1.
>
>Sure, but say that someone uses whatever iproute2 version <=
>iproute2-2.6.26 - which does not check for any ABI version numbering
>AFAICS - and then it compiles whatever >= 1.4.2-rc1 by hand, then
>jamal's ipt thing will not work as they use different ABIs.
>
>I'm not talking on how to solve future interdependecy problems - which
>you seems to have it done by exporting xtables as library - but the
>problems that the size change of .name will trigger for some time.

If the ABI changes, the libxtables.so ABI version number just get
bumped, that is what they are there for.
