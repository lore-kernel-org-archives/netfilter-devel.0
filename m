From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Tue, 2 Feb 2016 17:34:02 +0100
Message-ID: <20160202163402.GA3998@salvia>
References: <20160201175625.GA2421@salvia>
 <1454419553.4393.4@x201s.roaming.asbjorn.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756018AbcBBQeI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2016 11:34:08 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 51442581
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 17:34:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 43049DA7FF
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 17:34:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5A197DA801
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 17:34:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1454419553.4393.4@x201s.roaming.asbjorn.biz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 02, 2016 at 03:55:53PM +0000, Asbj=F8rn Sloth T=F8nnesen wr=
ote:
> Keeping them also makes it possible to inject funky bitmasks.

Good point, will get another look into these remaining patchset asap.
Busy with netdev 1.1 organization stuff.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
