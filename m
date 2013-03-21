From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Drop a packet while keeping the conntrack alive
Date: Thu, 21 Mar 2013 02:53:06 +0100
Message-ID: <20130321015306.GB3779@localhost>
References: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Nicolas =?iso-8859-1?Q?Ma=EEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45073 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab3CUBxL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:53:11 -0400
Content-Disposition: inline
In-Reply-To: <CACd4Q01yBxCJo8XcvY8+_HDqkuQG9Zz7=x6BGKdGCh7MA2oFHw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Nicolas,

On Thu, Mar 21, 2013 at 01:57:33AM +0100, Nicolas Ma=EEtre wrote:
> Hi,
>=20
> I've developed a connection tracking module which I'd like to use for
> detecting packets that may be dropped with an iptables rule.
> That is, the connection tracker can detect that a packet is not  vali=
d
> in the context of the tracked connection. So, I'd like the
> administrator to be able to add a rule that would allow to drop/rejec=
t
> that packet.
> A possible use case is to block packets from an attacker (assumed as
> such as the packet is not conform considering the current state of th=
e
> connection).
>=20
> As far as I understand it, the connection tracker usually handle this
> by returning a negative/null value (-NF_ACCEPT, NF_DROP, ...) which
> marks the packet invalid, so that it is possible to use the
> xt_conntrack extension to match it.
>=20
> I've looked at the TCP connection tracker. If I understand well, the
> current behavior is that if we've got an INVALID packet, it kills the
> conntrack, then create it again if we see an ACK later on. Am I right=
?

Packets that are invalid do not destroy the conntrack entry. The TCP
tracker explicitly destroys the entry by calling nf_ct_kill function
in some situations (RST seen / tracking is out-of-sync).
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
