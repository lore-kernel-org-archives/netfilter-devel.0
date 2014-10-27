From: Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH netfilter] Fix Unknown symbols in nf_reject_ipvX
 modules
Date: Mon, 27 Oct 2014 12:50:28 +0800
Message-ID: <1414385428.2312.1.camel@TP420>
References: <1414135732.19476.10.camel@TP420> <20141024094743.GA3628@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:49654 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbaJ0EvB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Oct 2014 00:51:01 -0400
Received: from /spool/local
	by e06smtp13.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <netfilter-devel@vger.kernel.org> from <zhong@linux.vnet.ibm.com>;
	Mon, 27 Oct 2014 04:51:00 -0000
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
	by d06dlp01.portsmouth.uk.ibm.com (Postfix) with ESMTP id DCC3417D8047
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2014 04:50:58 +0000 (GMT)
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s9R4ouQs18743748
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2014 04:50:56 GMT
Received: from d06av01.portsmouth.uk.ibm.com (localhost [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s9R4ouv0017477
	for <netfilter-devel@vger.kernel.org>; Sun, 26 Oct 2014 22:50:56 -0600
In-Reply-To: <20141024094743.GA3628@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On =E4=BA=94, 2014-10-24 at 11:47 +0200, Pablo Neira Ayuso wrote:
> On Fri, Oct 24, 2014 at 03:28:52PM +0800, Li Zhong wrote:
> > Commit c8d7b98bec43 moved nf_send_resetX() to modules without modul=
e
> > license, which causes following errors seen on my system:=20
> >=20
> > [   26.926014] nf_reject_ipv4: Unknown symbol rcu_read_lock_bh_held=
 (err 0)
> > [   26.926022] nf_reject_ipv4: Unknown symbol rcu_read_lock_held (e=
rr 0)
> > [   26.926030] nf_reject_ipv4: Unknown symbol ip_local_out_sk (err =
0)
> >=20
> > The code below adds MODULE_LICENSE("GPL") to fix this issue.=20
>=20
> We already sent a similar patch that should hit Linus' tree soon.

Ah, Ok, good to know.=20

Sorry for the noise :)

>=20
> Sorry for the inconvenience.
>=20


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
