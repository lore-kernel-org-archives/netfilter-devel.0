From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2 libnftnl] Check all strdup
Date: Tue, 7 Jun 2016 17:08:10 +0200
Message-ID: <20160607150810.GA17951@salvia>
References: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55125 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515AbcFGPIX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:08:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E5C1F921778
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:08:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D02EB9EBAF
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:08:21 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 51C709EBAF
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:08:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464689312-8136-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Carlos,

On Tue, May 31, 2016 at 12:08:32PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Check all strdup possible error and treat it consequently.

Please, manually apply these two patches in your local working copy:

http://patchwork.ozlabs.org/patch/631659/
http://patchwork.ozlabs.org/patch/631660/

Then, continue with the patch that I'm attaching.

As you can see, the idea is to return an integer for _set_data() and
_set_str(), so the caller can check if the internal string allocation
that the library performs has failed.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
