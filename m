From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: expectation entry creation with conntrack
Date: Fri, 26 Jun 2015 10:11:26 +0200
Message-ID: <20150626081126.GA10342@salvia>
References: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pfeiffer.szilard@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47658 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbbFZIGE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jun 2015 04:06:04 -0400
Content-Disposition: inline
In-Reply-To: <1435227731-15872-1-git-send-email-pfeiffer.szilard@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 25, 2015 at 12:22:09PM +0200, pfeiffer.szilard@balabit.hu w=
rote:
>=20
> Hello,
>=20
> Here are two patches that fix the expectation entry creation with con=
ntrack
> tool. First patch is only a refactor with the purpose to make the sec=
ond
> patch smaller and easier to understand. The second one fixes the entr=
y
> creation by using the necessary conntrack stucture.

Series applied, thanks Szil=E1rd.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
