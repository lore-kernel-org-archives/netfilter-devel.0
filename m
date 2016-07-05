From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] Fix string length calculations
Date: Tue, 5 Jul 2016 14:31:25 +0200
Message-ID: <20160705123125.GA27152@salvia>
References: <20160701142247.GA8806@salvia>
 <1467389503-27143-1-git-send-email-carlosfg@riseup.net>
 <20160702065316.GA26375@salvia>
 <5778E53E.60607@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37812 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755046AbcGEMbb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jul 2016 08:31:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 52CA4209907
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:31:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 426899EBC2
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:31:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36212FAB58
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jul 2016 14:31:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <5778E53E.60607@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jul 03, 2016 at 12:13:18PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> >>diff --git a/src/trace.c b/src/trace.c
> >>index d8f561d..1a50390 100644
> >>--- a/src/trace.c
> >>+++ b/src/trace.c
> >>@@ -165,13 +165,13 @@ const void *nftnl_trace_get_data(const struct=
 nftnl_trace *trace,
> >>  		*data_len =3D sizeof(uint32_t);
> >>  		return &trace->type;
> >>  	case NFTNL_TRACE_CHAIN:
> >>-		*data_len =3D strlen(trace->chain);
> >>+		*data_len =3D strlen(trace->chain) + 1;
> >>  		return trace->chain;
> >>  	case NFTNL_TRACE_TABLE:
> >>-		*data_len =3D strlen(trace->table);
> >>+		*data_len =3D strlen(trace->table) + 1;
> >>  		return trace->table;
> >>  	case NFTNL_TRACE_JUMP_TARGET:
> >>-		*data_len =3D strlen(trace->jump_target);
> >>+		*data_len =3D strlen(trace->jump_target) + 1;
> >>  		return trace->jump_target;
> >>  	case NFTNL_TRACE_TRANSPORT_HEADER:
> >>  		*data_len =3D trace->th.len;
> >Are you really sure we need this chunk too?
> Yes, I think the user would expect that 'data_len' means data length =
instead
> of data length minus one.
>=20
> When checking other getters I realized that in most cases we keep the
> parameter 'data_len' unset when the user ask for a string. Maybe we c=
an fix
> these behavior, I think it make more sense if our getters always retu=
rn the
> data length instead of keep an inconstant behavior.

_get() for strings functions should retain the strlen() semantics.

So I'd suggest you just fix the string setters.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
