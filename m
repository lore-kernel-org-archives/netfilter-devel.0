From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] xtables: use exponential delay when waiting for
 xtables lock
Date: Thu, 28 Apr 2016 11:25:41 +0200
Message-ID: <20160428092541.GB1529@salvia>
References: <1460084845-28057-1-git-send-email-subashab@codeaurora.org>
 <CAML_gOfhesCGBk5WWpmAsi3GQNHu5ZZpe9Wg36HCjGgQuRNeOg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
	netfilter-devel@vger.kernel.org
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983AbcD1JZu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Apr 2016 05:25:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E4EC4BA0C
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0EEA26446E
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 113C6A734
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2016 11:25:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOfhesCGBk5WWpmAsi3GQNHu5ZZpe9Wg36HCjGgQuRNeOg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 28, 2016 at 09:37:32AM +0800, Liping Zhang wrote:
> 2016-04-08 11:07 GMT+08:00 Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>:
> > @@ -257,10 +258,15 @@ bool xtables_lock(int wait)
> >                         return true;
> >                 else if (wait >= 0 && waited >= wait)
> >                         return false;
> > -               if (++i % 2 == 0)
> > +               if ((++i % 2 == 0) && (base_delay >= 200000))
> >                         fprintf(stderr, "Another app is currently holding the xtables lock; "
> >                                 "waiting (%ds) for it to exit...\n", waited);
> >                 waited++;
> > -               sleep(1);
> 
> This break the "-w" option's semantic, i.e. if the user input
> "iptables -w 1", and concurrency happen,
> we will just only wait 10ms and return an error.

If there's any chance this patch can break existing setups then we
can't take this.

I'd suggest you add support to express millisecond precision using a
dot notation, ie.

        -w .000001

that means 10 ms.
