From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH] tests: shell: add a basic scapy test
Date: Wed, 30 Nov 2016 19:27:04 +0100
Message-ID: <20161130182704.GA7892@salvia>
References: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, shivanib134@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42070 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754403AbcK3S1O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2016 13:27:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFDE211E581
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF6D9DA853
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:27:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B491BDA861
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2016 19:27:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <148049874652.26121.17744801893432354214.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 30, 2016 at 10:39:06AM +0100, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo@debian.org>
> 
> This test uses scapy to send a packet and test our packet/data path.
> We grep the 'nft list ruleset' output for a counter increment.
> 
> If we like this approach, then we could easily add more testcases
> following the pattern in this patch.

I think it's been several netfilter workshops already talking on this,
but it never happens because nobody pushed this forward.

If you can make this happen, it would great. Testing the datapath is
something that we always wanted to have.

Several ideas:

* Check if you can use the dummy interface, so we make sure no other
  packets interfer with the tests.

* You can probably augment this at some pointer to rely on the new
  nf_tables tracing infrastructure.

Anyway, I agree that starting with something simple is good enough.
