From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Doc on writing conntrack module?
Date: Sun, 5 Feb 2012 18:15:34 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1202051814500.28756@frira.zrqbmnf.qr>
References: <jgmc9i$mid$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:37888 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2BERPg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:15:36 -0500
In-Reply-To: <jgmc9i$mid$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-02-05 17:55, Ian Pilcher wrote:

>I would like to write a conntrack module for the Simple Service
>Discovery Protocol (SSDP):
>
>    http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
>
>This certainly seems like it should be reasonably straightforward, but
>I'm having trouble relating the documentation in the Hacking HOWTO to
>what I see in the actual kernel (in nf_conntrack_snmp.c, for example).
>Hardly surprising, given the age of the HOWTO.
>
>Is there any more recent documentation?

"Writing Netfilter Modules" PDF, though arguably the conntrack sections 
are thin.
