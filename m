From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl, v2] fix some error checking in parser functions
Date: Wed, 22 Jun 2016 19:24:34 +0200
Message-ID: <20160622172434.GA3755@salvia>
References: <1466418559-4495-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40640 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbcFVRYj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:24:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 467A3E8E85
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:24:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 36AE264478
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:24:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 369B9A827A
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:24:35 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466418559-4495-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 12:29:19PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Use a variable 'ret' multiple times without treat the error between c=
an
> overwrite the previous error value, and may execute code which should=
 not.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
