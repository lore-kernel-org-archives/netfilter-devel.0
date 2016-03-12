From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] extensions: libip6t_LOG: Avoid to print the default log
 level in the translation
Date: Sat, 12 Mar 2016 12:42:51 +0100
Message-ID: <20160312114251.GA2173@salvia>
References: <1457725772-10913-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Roberto =?iso-8859-1?Q?Garc=EDa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbcCLLm4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 06:42:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 13E0D4B9E4
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:42:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 037BEDA8F9
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:42:55 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 196ECDA385
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:42:53 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1457725772-10913-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 11, 2016 at 08:49:32PM +0100, Roberto Garc=EDa wrote:
> Remove the log level when default is used
>=20
> Before:
> 	$ sudo iptables-translate -I INPUT -j LOG
> 	nft add rule filter INPUT log level warning
>=20
> After:
> 	$ sudo iptables-translate -I INPUT -j LOG
> 	nft add rule filter INPUT counter log

Applied, thanks Roberto!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
