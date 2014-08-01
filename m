From: Florian Westphal <fw@strlen.de>
Subject: Re: what is the default value of
 /proc/sys/net/netfilter/nf_conntrack_helper ?
Date: Fri, 1 Aug 2014 20:19:55 +0200
Message-ID: <20140801181955.GA9602@breakpoint.cc>
References: <53DBD885.4060707@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Toralf =?iso-8859-15?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54845 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754982AbaHAST5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:19:57 -0400
Content-Disposition: inline
In-Reply-To: <53DBD885.4060707@gmx.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Toralf F=F6rster <toralf.foerster@gmx.de> wrote:
>=20
> The doc in states :
>=20
> nf_conntrack_helper - BOOLEAN
>         0 - disabled
>         not 0 - enabled (default)
>=20
>         Enable automatic conntrack helper assignment.
>=20
>=20
> but is that still true ?

Yes.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
