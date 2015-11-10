From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft 0/6] flow statement
Date: Tue, 10 Nov 2015 19:26:03 +0100
Message-ID: <20151110182603.GA1492@salvia>
References: <1446834863-18610-1-git-send-email-kaber@trash.net>
 <20151110165156.GA3227@salvia>
 <CAJO99TnH43njpQ-5wO7Ar6jytmqzF4Y2wCr+DNhTWr7_MgtR8g@mail.gmail.com>
 <20151110182344.GD25929@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: =?iso-8859-1?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47292 "EHLO salida-rhel7.int"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752851AbbKJS0K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Nov 2015 13:26:10 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by salida-rhel7.int (Postfix) with ESMTP id 342331373C1
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 19:26:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 241FD9DCA3
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 19:26:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A1829DCA3
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2015 19:26:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151110182344.GD25929@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 10, 2015 at 06:23:45PM +0000, Patrick McHardy wrote:
> On 10.11, Bj=F8rnar Ness wrote:
> > System hangs here if I do the following:
> >=20
> > add a flow table
> >=20
> > list flowtable, cant make nft list flow table work, so do nft list =
set
> > filter test
> >=20
> > flush rules and change flowtable concat, for example adding . ip sa=
ddr
> >=20
> > everything seemingly fine this far, but if I now list set filter te=
st,
> > system becomes
> > unresponsive, and a boot seems needed.
>=20
> Please provide the exact commands you used.

If you using counters, the patches I just posted should resolve the
problem.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
