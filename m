From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Regarding connection mappings to module data structures
Date: Thu, 14 Jun 2012 20:27:50 +0200
Message-ID: <20120614182750.GA10798@1984>
References: <1339654713.58676.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Deepak Jangid <deepak_jangid1987@yahoo.co.in>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41187 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755387Ab2FNS15 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 14:27:57 -0400
Content-Disposition: inline
In-Reply-To: <1339654713.58676.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 14, 2012 at 02:18:33PM +0800, Deepak Jangid wrote:
> Hello Netfilter team,
> =A0
> I am seeking an infrastructure for mapping
> conntrack(struct nf_conn) to a module private data structure as a con=
text for
> every connection.
> I could not find any such.
> =A0
> I can add the private info when I see a new connection.
> conntrack destroy events can be caught to destroy the
> private structure.
> But the thing is there is no mechanism to store the
> private info mapped to a connection. Either I will have to maintain
> hash-tables, which is highly irrelevant, or edit the nf_conn which se=
ems a
> better way.
> =A0
> What I was thinking is to have a list_head or a pointer
> to a structure in nf_conn which can handle such scenarios.
> =A0
> Does this seems generic ? Well yes there is
> conntrack_extend, but it is not generic to be usable by other modules=
=2E

It's hard to understand what you need since you don't provide any
information on what you want to do.

But my guess is that conntrack extensions is what you want. See
net/netfilter/nf_conntrack_extend.c and
net/netfilter/nf_conntrack_timestamp.c for one example.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
