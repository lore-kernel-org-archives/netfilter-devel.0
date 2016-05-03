From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_ct_helper: disable automatic
 helper assignment
Date: Wed, 4 May 2016 00:25:32 +0200
Message-ID: <20160503222532.GB1006@salvia>
References: <1460646821-15401-1-git-send-email-pablo@netfilter.org>
 <CAPWQB7EyGi2XpfS9LAnwBf7eNjiPDwC_FVnxAW_4iYHrp9NObg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Joe Stringer <joe@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756574AbcECWZi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 May 2016 18:25:38 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 452B8E5A64
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:25:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3726633AB
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:25:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 49C6C6447A
	for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2016 00:25:33 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAPWQB7EyGi2XpfS9LAnwBf7eNjiPDwC_FVnxAW_4iYHrp9NObg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 03, 2016 at 03:21:00PM -0700, Joe Stringer wrote:
> On 14 April 2016 at 08:13, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Four years ago we introduced a new sysctl knob to disable automatic
> > helper assignment in 72110dfaa907 ("netfilter: nf_ct_helper: disable
> > automatic helper assignment"). This knob kept this behaviour enabled by
> > default to remain conservative.
> 
> Presumably you mean a9006892643a ("netfilter: nf_ct_helper: allow to
> disable automatic helper assignment").

Argh, right. Will fix this in the pull request message.
