From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnftnl: gitignore: Fix mistake in gitignore regexp
Date: Fri, 20 May 2016 11:46:39 +0200
Message-ID: <20160520094638.GA7990@salvia>
References: <1463512299-1105-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36345 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274AbcETJqq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 05:46:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 57377E5A54
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 32A50A8FA
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:46:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1B76FD1D8B
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:46:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463512299-1105-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 17, 2016 at 09:11:39PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> If a whole directory was ignored, files inside it will not be checked=
=2E

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
