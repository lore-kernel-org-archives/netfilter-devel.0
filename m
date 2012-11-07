From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH] pgsql: add SSL connection implementation to PGSQL plugin
Date: Wed, 07 Nov 2012 09:41:08 +0100
Message-ID: <1352277668.3652.43.camel@tourtet>
References: <1346503911-3781-1-git-send-email-mr.dash.four@googlemail.com>
		 <20120902233228.GA22069@1984> <50440A1B.7060908@googlemail.com>
	 <1346653997.5194.37.camel@tiger.regit.org> <50449BF1.40005@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56868 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGIlS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:41:18 -0500
In-Reply-To: <50449BF1.40005@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Le lundi 03 septembre 2012 =C3=A0 13:00 +0100, Mr Dash Four a =C3=A9cri=
t :
> >> Sure. Are there any (other) objections to the patch I submitted?
> >>    =20
> >
> > I've applied the current patch to give it a run. And it shows a lot=
 of
> > whitespace errors. You'll need to fix it too.
> >  =20
> What do you mean by that?

There's a lot of spaces at end of lines or empty lines containing only
spaces. Basically, s/ +$// to fix it.

BR,
--
Eric Leblond

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
