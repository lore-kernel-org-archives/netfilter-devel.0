From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: validate NFTA_SET_TABLE
 parameter
Date: Mon, 30 May 2016 11:33:30 +0200
Message-ID: <20160530093330.GA28021@salvia>
References: <1464370444-28312-1-git-send-email-phil.turnbull@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	coreteam@netfilter.org
To: Phil Turnbull <phil.turnbull@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37341 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932219AbcE3Jdg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 05:33:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 370F91C0969
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2781515D62E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC57D15D633
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 11:33:32 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464370444-28312-1-git-send-email-phil.turnbull@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 27, 2016 at 01:34:04PM -0400, Phil Turnbull wrote:
> If the NFTA_SET_TABLE parameter is missing and the NLM_F_DUMP flag is
> not set, then a NULL pointer dereference is triggered in
> nf_tables_set_lookup because ctx.table is NULL.

Applied, thanks.
