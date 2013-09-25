From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2 1/2] rule: json: Fixed wrong offset return
Date: Wed, 25 Sep 2013 22:11:55 +0200
Message-ID: <20130925201155.GA9862@localhost>
References: <20130924125410.18650.33470.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34365 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754584Ab3IYUMB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:12:01 -0400
Content-Disposition: inline
In-Reply-To: <20130924125410.18650.33470.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Sep 24, 2013 at 02:54:10PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> I have fixed the offset because when i try to print more of one rule,
> the json output support only print one rule because this function ret=
urn
> a wrong offset value

Mangled and applied a similar, but better solution for this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
