From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4 v2] libnftnl: set: Implement new buffer of TLV
 objects.
Date: Fri, 8 Jan 2016 14:41:27 +0100
Message-ID: <20160108134127.GA24063@salvia>
References: <1451999013-4313-1-git-send-email-carlosfg@riseup.net>
 <1451999013-4313-2-git-send-email-carlosfg@riseup.net>
 <20160105132847.GA24311@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>,
	netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbcAHNll (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Jan 2016 08:41:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 736A3DA886
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 14:41:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 629FADA872
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 14:41:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7C808DA86E
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Jan 2016 14:41:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160105132847.GA24311@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Tue, Jan 05, 2016 at 02:28:47PM +0100, Florian Westphal wrote:
> Carlos Falgueras Garc=EDa <carlosfg@riseup.net> wrote:
> > These functions allow create a buffer (nftnl_attrbuf) of TLV object=
s
> > (nftnl_attr). It is inspired in libmnl/src/attr.c.
>=20
> It would be nice to get a summary on how this going to be used.
>=20
> At this time I don't understand why nftnl needs this api,
> the kernel doesn't enforce any format on this data (good), so we cann=
ot
> rely on it having any specific format when reading arbitrary userdata
> (added by someone else).

Since the introduction of concatenations, the NFTA_SET_DATA_TYPE
attribute became too short to store the datatype information that we
need to keep to interpret the elements datatypes. This field is very
useful when dumping things from the kernel, to interpret them given
that the kernel side has no understanding on the byte semantics that
it is storing.

Another problem is that we also don't want to have fixed integer
datatypes since we can also have header bitfields into sets, this
would also explode in number when consider host and network byteorder
variants, so the idea is to store this in flexible TLV format in the
set userdata area.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
