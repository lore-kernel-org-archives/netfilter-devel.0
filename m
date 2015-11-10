From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Tue, 10 Nov 2015 17:51:56 +0100
Message-ID: <20151110165156.GA3227@salvia>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57884 "EHLO salida-rhel7.int"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754419AbbKJQv7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 11:51:59 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by salida-rhel7.int (Postfix) with ESMTP id 30FD961515
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:51:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1F751A7BCB
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:51:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 51BB9D192A
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 17:51:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1446834863-18610-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

On Fri, Nov 06, 2015 at 06:34:17PM +0000, Patrick McHardy wrote:
> The following patches add support for the flow statement, which allows to
> dynamically instantiate stateful statements fow an arbitrary defined flow
> key.
>
> Currently we have to stateful statements, counter and limit. This example
> shows some accounting possibilities using the counter statement. Please note
> that the output format is still WIP and not included in this patchset:
>
> # nft filter input flow table test iif . tcp flags counter

This looks very good to me :-).

> # nft list flow table filter test
> iface_index	tcp_flag	statement
> lo		fin | psh | urg	counter packets 1002 bytes 40080
> wlp2s0		fin | ack	counter packets 3 bytes 156
> wlp2s0		ack		counter packets 32 bytes 18440
> wlp2s0		syn | ack 	counter packets 5 bytes 300
> wlp2s0		psh | ack	counter packets 57 bytes 13804
> lo		rst | ack	counter packets 998 bytes 39920
> 
> # nft filter output flow table uidacct skuid . oif . ip protocol counter
> # nft list flow table filter uidacct

BTW, I can see the content is currently listed (in the non-pretty
output format) through:

        nft list set filter test

so I can see how that flow table gets populated with entries.

>From the syntax perspective, I'm aware this the general definition in
the industry for this is 'flow table' but my only concern here with
this denomination is that we already have in our own tables with quite
different semantics.

Moreover, the fact that we can list this as sets (since they are
actually using the generic nf_tables set infrastructure) may be
confusing to users.

BTW, should we have implicit and explicit flow tables just like sets?

Thanks!
