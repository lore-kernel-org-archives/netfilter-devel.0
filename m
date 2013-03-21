From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Drop a packet while keeping the conntrack alive
Date: Thu, 21 Mar 2013 17:07:20 +0100
Message-ID: <20130321160720.GA14783@localhost>
References: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
 <20130321015306.GB3779@localhost>
 <CACd4Q00XP-OS8=9QM-Oyks9sp2qSGzQBYLHvmCh6r3J-JgjjWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Nicolas =?iso-8859-1?Q?Ma=EEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33935 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933900Ab3CUQH2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Mar 2013 12:07:28 -0400
Content-Disposition: inline
In-Reply-To: <CACd4Q00XP-OS8=9QM-Oyks9sp2qSGzQBYLHvmCh6r3J-JgjjWA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 21, 2013 at 04:17:47PM +0100, Nicolas Ma=EEtre wrote:
> On Thu, Mar 21, 2013 at 2:53 AM, Pablo Neira Ayuso <pablo@netfilter.o=
rg> wrote:
> > Packets that are invalid do not destroy the conntrack entry. The TC=
P
> > tracker explicitly destroys the entry by calling nf_ct_kill functio=
n
> > in some situations (RST seen / tracking is out-of-sync).
>=20
> Well, it means that nf_conntrack_put doesn't kill the conntrack as I
> thought. I still can't understand how the nfct from skb works. What i=
s
> that "use" value that makes nf_conntrack_put() call
> nf_conntrack_destroy() when it equals zero?

That "use" field in the nf_conn object is a refcounter. In SMP, you
may have several packets traveling through the stack referencing to
the same conntrack object. The refcount is initially set to 1 because
there is a timer that releases the conntrack if it expires.

You may also have a conntrack entries that are related to another
master conntrack (eg. FTP helper scenario: the control flow is the
master conntrack, and all data flows are related to it). In that case,
the refcount is also incremented depending on the amount of references
to it.

nf_conntrack_find_get increments the refcount, nf_ct_put decrements it
and it checks if it has become 0, in that case the nf_conn object is
released.

This article may help you to understand better how conntrack works:

https://www.usenix.org/publications/login/june-2006-volume-31-number-3/=
netfilters-connection-tracking-system

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
