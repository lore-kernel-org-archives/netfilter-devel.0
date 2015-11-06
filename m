From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: Add command "replace" for rules
Date: Fri, 6 Nov 2015 14:42:35 +0100
Message-ID: <20151106134235.GA7030@salvia>
References: <1445947087-25861-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49871 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1033190AbbKFNfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 08:35:12 -0500
Content-Disposition: inline
In-Reply-To: <1445947087-25861-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 27, 2015 at 12:58:07PM +0100, Carlos Falgueras Garc=EDa wro=
te:
> Modify the parser and add necessary functions to provide the command =
"nft
> replace rule <ruleid_spec> <new_rule>"
>=20
> Example of use:
> 	# nft list ruleset -a
> 	table ip filter {
> 		chain output {
> 			ip daddr 8.8.8.7 counter packets 0 bytes 0 # handle 3
> 		}
> 	}
> 	# nft replace rule filter output handle 3 ip daddr 8.8.8.8 counter
> 	# nft list ruleset -a
> 	table ip filter {
> 		chain output {
> 			ip daddr 8.8.8.8 counter packets 0 bytes 0 # handle 3
> 		}
> 	}

Applied, thanks Carlos.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
