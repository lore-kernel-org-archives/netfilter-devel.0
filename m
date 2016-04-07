From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-translate: Moving of printing nft back to
 xtables_xlate_main
Date: Thu, 7 Apr 2016 11:51:16 +0200
Message-ID: <20160407095116.GB2959@salvia>
References: <20160331183624.GA7030@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51388 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755429AbcDGJvV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:51:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 4687C4B9FA
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:51:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 389DBDA38A
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:51:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A9EF5DA391
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:51:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160331183624.GA7030@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 01, 2016 at 12:06:24AM +0530, Guruswamy Basavaiah wrote:
> Moving of printing "nft" back to xtables_xlate_main from
>  function do_command_xlate.
> 
> This reverts of previous commit 4f75601d37349c5a983a969d46c1ff0604991b5c
> which was breaking "iptables-restore-translate -f" and "./nft -f"

Instead of reverting, you can probably check:

        if (!restore)
                printf("nft ");

so the nft keyword is not shown via iptables-restore-translate.
