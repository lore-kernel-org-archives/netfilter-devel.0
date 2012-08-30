From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH] death_by_event() does not check IPS_DYING_BIT - race condition against ctnetlink_del_conntrack
Date: Thu, 30 Aug 2012 04:05:35 +0200
Message-ID: <2370728.VmAJL45mX9@gentoovm>
References: <7353554.n89QJXU3eh@gentoovm> <1605551.o4ZNqbFbkc@gentoovm> <20120830005236.GA8127@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:38996 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab2H3CF3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Aug 2012 22:05:29 -0400
In-Reply-To: <20120830005236.GA8127@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 30 August 2012 02:52:36 you wrote:
> The problem seems to be the re-use of the conntrack timer. Races may
> happen in entries that were just inserted in the dying list while
> packets / ctnetlink still hold a reference to them.
> 
> Would you give a try to this patch? Please, remove the previous I
> sent.
> 
> Let me know if you hit more crashes. Thanks.

Hi Pablo,

I successfully appied the patch against 3.4.10 but it is failing to compile, 
likely because of a lack of definition for the ecache struct.

the specific error from gcc is:

net/netfilter/nf_conntrack_core.c:258:9: error: dereferencing pointer to 
incomplete type

(plus all the other relevant lines using the ecache ptr)

Kind Regards,
Oliver
