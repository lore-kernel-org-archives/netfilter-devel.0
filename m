From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] extensions: libxt_cluster: add note on
 arptables-jf
Date: Wed, 6 Nov 2013 19:14:08 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1311061913240.29424@nerf07.vanv.qr>
References: <1383562439-12113-1-git-send-email-pablo@netfilter.org> <Pine.LNX.4.64.1311041234290.13395@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:48584 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750747Ab3KFSOK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Nov 2013 13:14:10 -0500
In-Reply-To: <Pine.LNX.4.64.1311041234290.13395@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2013-11-04 12:39, Jesper Dangaard Brouer wrote:
> On Mon, 4 Nov 2013, Pablo Neira Ayuso wrote:
>
>> Gao feng reported problems while getting the cluster match working with
>> arptables. This patch adds a note in the manpage to warn about the
>> arptables-jf
>> syntax, which is different from mainstream arptables.
>
> While on the subject of arptables_jf.  Red Hat will be replacing arptables_jf
> with the mainstream arptables in RHEL7 and Fedora 21.

And I thought it'd never happen ;)
I still wonder why they even created the fork. There's little documentation
about that.
