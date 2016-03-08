From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4 v3] libnftnl: Implement new buffer of TLV objects.
Date: Tue, 8 Mar 2016 14:14:26 +0100
Message-ID: <20160308131426.GD5125@salvia>
References: <1457433811-18285-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43605 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbcCHNOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2016 08:14:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 22BEA8434
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:14:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 13690DA383
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:14:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 28904DA388
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Mar 2016 14:14:27 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457433811-18285-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 08, 2016 at 11:43:31AM +0100, Carlos Falgueras Garc=EDa wro=
te:
> These functions allow to create a buffer (nftnl_udata_buf) of TLV obj=
ects
> (nftnl_udata). It is inspired by libmnl/src/attr.c. It can be used to=
 store
> several variable length user data into an object.

Please, resubmit a full batch (containing all patches) in a new round.

Thanks Carlos!

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
