From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: helper: Fix helper unregister count.
Date: Tue, 24 May 2016 11:42:00 +0200
Message-ID: <20160524094200.GA2294@salvia>
References: <1463231993-26917-1-git-send-email-ap420073@gmail.com>
 <CA+6hz4pj-wp5Vye6GSxiZM1-Bfq=qcJCUJD0hjEbmmtRsTfhow@mail.gmail.com>
 <20160524092608.GA2132@salvia>
 <CA+6hz4qEt7CMCuTAf+8ik2LGUJ7SLVuSkkd8VCbgvL4MehEsWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Taehee Yoo <ap420073@gmail.com>, Patrick McHardy <kaber@trash.net>,
	kadlec@blackhole.kfki.hu,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53537 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbcEXJmG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2016 05:42:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id A51AF114803
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:42:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9426E15D642
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:42:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2593315D637
	for <netfilter-devel@vger.kernel.org>; Tue, 24 May 2016 11:42:01 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4qEt7CMCuTAf+8ik2LGUJ7SLVuSkkd8VCbgvL4MehEsWQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 24, 2016 at 05:32:43PM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> I remember my original commit is very simple.
> Just a few lines changes.
> 
> Then I make it more complicated according to your comments

Are you refering to this?

http://patchwork.ozlabs.org/patch/522709/

I suggested this specifically: "Could you investigate if it would be
possible to add a nf_conntrack_helpers_register()?"

Then, you followed up with a patchset that was fixing and reworking in
the same go.

The usual procedure is to split the submissions in logical changes,
starting from fixes (that are always prioritized) and then follow up
with rework/improvements/new features.

I also remember that at some point you withdrew indicating that there
was a problem, then came back telling this was OK, which confused me.
