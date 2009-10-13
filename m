From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Doubts in netfilter limit match
Date: Tue, 13 Oct 2009 22:25:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910132221130.1767@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Balaji Venkatamohan <bvenkat@ncsu.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51137 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbZJMU0P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:26:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables -A INPUT -s 127.0.0.1 -m limit --limit-burst 5

>I want to know how and where the count is stored. Are they checked for
>previous entries using netfilter log?

The count is stored within the private data associated with each
-m limit instance. Actually it's not a count but some bucket fill level 
value. See xt_limit.c for details.
