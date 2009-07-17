From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Understanding execution context of netfilter hooks
Date: Fri, 17 Jul 2009 21:19:00 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907172100370.18553@fbirervta.pbzchgretzou.qr>
References: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stefan Hellkvist <hellkvist@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40862 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZGQTTD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jul 2009 15:19:03 -0400
In-Reply-To: <704c29930907170950l6e2f9881j83dbe338b9c03bdf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-07-17 18:50, Stefan Hellkvist wrote:
>
>Could anyone help me understand the execution context under which
>netfilter hooks are being executed?

If I am not mistaken, SIRQ context, including the no-nos that
come with it. Reading files sure is one.

>Then it will fail with an "Oops: 0000 [#2]" "BUG: unable to handle
>kernel NULL pointer dereference at 0000000f" when you trigger it with
>some network traffic. The last call in the stack-trace of the OOPS
>shows vfs_read (called by kernel_read) being the culprit (possibly
>because it's being executed in the wrong context).
>
>So, the question, as mentioned in the beginning. What context is the
>hook executing in which causes the code to behave differently from
>when it executed in the module init method for instance?

module_init either runs as user or kthread context. Your reading
of files would most likely also fail in the latter.
