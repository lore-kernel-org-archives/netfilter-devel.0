From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Checkentry called twice?
Date: Tue, 31 Mar 2009 17:16:59 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0903311715510.1684@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903310416w788a6379pb8184013a068c6a9@mail.gmail.com>  <17e3a8f80903310503r3fd630d6m7822f406e3694d9d@mail.gmail.com>  <alpine.LSU.2.00.0903311428080.14162@fbirervta.pbzchgretzou.qr>  <17e3a8f80903310532v44eadf72we077a301d1199aa9@mail.gmail.com>
 <17e3a8f80903310546h123f8esafda204cea519ecb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51320 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbZCaPRE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:17:04 -0400
In-Reply-To: <17e3a8f80903310546h123f8esafda204cea519ecb@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-31 14:46, Kristian Evensen wrote:

>Sorry for asking stupid questions, by reading some sections of the
>book a bit more thorough I discovered that destroy is called after
>checkentry :) Now I also understand why quota2 uses lists.

The list is actually used so that we know what to show in procfs. As 
described in the book, quota and recent and so on work because the new 
table is checked first (which ups the refcount) before the old table 
dies (downing the refcount), so it's 1->2->1 instead of 1->0->1. So the 
data portions luckily don't go away while replacing a table.

>However, if there is a way to avoid replacing the table I am very
>interested in learning about it.

Nope.
