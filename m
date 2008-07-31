From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: concurrency problems in a netfilter target extension?
Date: Thu, 31 Jul 2008 13:33:15 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0807311330420.6855@fbirervta.pbzchgretzou.qr>
References: <4891C96A.20004@googlemail.com>  <alpine.LNX.1.10.0807311039180.6855@fbirervta.pbzchgretzou.qr> <379e30200807311021q349e121m665fe8a11b764db3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54195 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbYGaRdQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2008 13:33:16 -0400
In-Reply-To: <379e30200807311021q349e121m665fe8a11b764db3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-07-31 13:21, Tobias Koeck wrote:

>I've read that. But does it solve the problem in a target extension
>module? Will the modules only be cloned so that you have different
>data structures?

Which is why you allocate a separate structure, then let Netfilter clone 
it (shallow only) for percpu, so that in the end, you have one shared
structure regardless of the cloning operation.

>Or is only one instance in the memory and if one
>processor changes something every other threads will use the changed
>values?

Using this shared structure is then easy.
