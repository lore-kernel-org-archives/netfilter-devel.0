From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables v2 2/2] xtables-translate: fix issue with quotes
Date: Wed, 27 Jul 2016 13:58:29 +0200
Message-ID: <20160727115829.GB10687@salvia>
References: <20160726164524.29906-1-pablombg@gmail.com>
 <20160726164524.29906-2-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35190 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbcG0L6e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Jul 2016 07:58:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A08E11EC2C8
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8F13FFF6DD
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:58:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 83019FF2FD
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Jul 2016 13:58:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160726164524.29906-2-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 26, 2016 at 06:45:24PM +0200, Pablo M. Bermudo Garay wrote:
> Some translations included escaped quotes when they were called from
> nft:
> 
> $ sudo nft list ruleset
> table ip mangle {
>     chain FORWARD {
>         type filter hook forward priority -150; policy accept;
>         ct helper \"ftp\" counter packets 0 bytes 0
>                   ^^   ^^
>     }
> }
> 
> This behavior is only correct when xlate functions are called from a
> xtables-translate command. This patch solves that issue using a new
> parameter (escape_quotes) in the xlate functions.

Applied, thanks Pablo.
