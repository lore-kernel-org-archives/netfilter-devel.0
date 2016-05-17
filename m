From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnftnl: Add to .gitignore all auto-generated files
 when a "make check" is done
Date: Tue, 17 May 2016 12:29:29 +0200
Message-ID: <20160517102929.GA3048@salvia>
References: <1463402341-13221-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56943 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbcEQK3r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 May 2016 06:29:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id DA9181B7F85
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:29:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B5E7111D00C
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:29:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7FF211C4F1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2016 12:29:34 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463402341-13221-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 16, 2016 at 02:39:01PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> It ignores files inside "test/" and "examples/" except all c code (*.=
c) and the
> "Makefile.am"

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
