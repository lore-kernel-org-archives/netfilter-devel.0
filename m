From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: bugfix: fix regression bug in ebt_ip6 which resulted in ebtables
 IPv6 src/dst fields not being zeroed
Date: Tue, 19 Nov 2013 15:38:07 +0100
Message-ID: <20131119143807.GA7403@localhost>
References: <527AB6D0.8090605@uolinc.com>
 <528A7E44.5080909@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Luis Fernando Cornachioni Estrozi <lestrozi@uolinc.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33067 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278Ab3KSOiO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:38:14 -0500
Content-Disposition: inline
In-Reply-To: <528A7E44.5080909@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 18, 2013 at 09:53:24PM +0100, Bart De Schuymer wrote:
> Luis Fernando Cornachioni Estrozi schreef op 6/11/2013 22:39:
> >fix regression bug in ebt_ip6 which resulted in ebtables IPv6 src/ds=
t
> >fields not being zeroed

I think the problem is that IPv6 src/dst matching was broken.

> >Signed-off-by: Lu=EDs Fernando Cornachioni Estrozi <lestrozi@uolinc.=
com>
> Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>

This patch does not apply at all, it seems that it was probably
mangled by Luis Fernando's MUA.

I have fixed and applied this patch. Please, next time make sure your
patch applies cleanly, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
