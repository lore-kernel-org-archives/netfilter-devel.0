From: Patrick Schaaf <bof@bof.de>
Subject: Re: string match -> new option
Date: Sun, 2 Mar 2003 12:36:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030302113629.GC25876@oknodo.bof.de>
References: <15760529186.20030301025308@yahoo.es> <20030301063948.GF24025@oknodo.bof.de> <20030302095915.GC2296@naboo.clug.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Patrick Schaaf <bof@bof.de>,
  macadanet@yahoo.es,
  lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20030302095915.GC2296@naboo.clug.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Look at 'libqsearch' from Philipe Biondi.  (I don't have the URL here
> right now, but 'libqsearch' + 'kernel' on google gives you the result).

Thanks for the pointer! The homepage is at

	http://www.cartel-securite.fr/pbiondi/libqsearch.html

> This is the way to do pattern matching on TCP streams in the kernel...

Looks good at first glance, as a fast parallel pattern matcher. Really nice.

However, for full generality in application to TCP streams, one would
at least need an additional, upfront reorder step, to bring the
stream's packets into the correct order. If a packet it missing,
in the sequence, the search must be paused, with the question
of what to do with the already arrived head-of-sequence packet
(the packet after the perceived gap).

I still feel that such logic has already been implemented in the form
of the local network stack TCP layer; it would be wrong to reimplement
all of that in a separate stream matcher. That's why REDIRECT is my
preferred approach: it gets the packets through the TCP layer.

Thus, the critical question, to me, is less in the matching, than in
how to architect such a matching machinery above the TCP stack, without
paying the cost of a user level interface / application level gateway.
As occasionally mentioned, I think khttpd and the Tux web server are
the correct "role models" for a total solution to this really frequently
asked question. How to fit such a kernel daemon approach into configuration
by iptables?

Note that I don't feel like implementing anything like that, myself. No need,
no motivation.

best regards
  Patrick
