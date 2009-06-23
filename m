From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf_unregister_hook problem
Date: Tue, 23 Jun 2009 21:49:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0906232147280.32190@fbirervta.pbzchgretzou.qr>
References: <20090623154705.pm2z8cfi6oc4w0ow@webmail.inf.ufrgs.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: gmoliveira@inf.ufrgs.br
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49124 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbZFWTtF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:49:05 -0400
In-Reply-To: <20090623154705.pm2z8cfi6oc4w0ow@webmail.inf.ufrgs.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-06-23 20:47, gmoliveira@inf.ufrgs.br wrote:
>
>im using this:
>
>init_timer(&foo2);
>stop_trigger.function = nf_unregister_hook;
>stop_trigger.data = &nf_hook;
>stop_trigger.expires = jiffies + msecs_to_jiffies(HZ * 5000);
>add_timer(&foo2);
>
>it works to every function until now, unless nf_unregister_hook.

Does the problem go away if you call it indirectly? Like:


stop_trigger.function = myfunc;
...

myfunc(void)
{
	nf_unregister_hook(&nf_hook);
}

