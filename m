Return-Path: <SRS0=ntVu=Z7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 625F3C43603
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 11:58:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F2EB2077B
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Dec 2019 11:58:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfLIL6L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Dec 2019 06:58:11 -0500
Received: from correo.us.es ([193.147.175.20]:57878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfLIL6L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Dec 2019 06:58:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 985EE4DE733
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 12:58:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B823DA713
        for <netfilter-devel@vger.kernel.org>; Mon,  9 Dec 2019 12:58:08 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80722DA70D; Mon,  9 Dec 2019 12:58:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 86EDEDA703;
        Mon,  9 Dec 2019 12:58:06 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 12:58:06 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5874B4265A5A;
        Mon,  9 Dec 2019 12:58:06 +0100 (CET)
Date:   Mon, 9 Dec 2019 12:58:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH netfilter] netfilter: bridge: make sure to pull arp
 header in br_nf_forward_arp()
Message-ID: <20191209115806.6shehffmjvlazdd2@salvia>
References: <20191207224339.91704-1-edumazet@google.com>
 <20191208233155.GH795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191208233155.GH795@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 09, 2019 at 12:31:55AM +0100, Florian Westphal wrote:
> Eric Dumazet <edumazet@google.com> wrote:
[...]
> >  		nf_bridge_pull_encap_header(skb);
> >  	}
> >  
> > +	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
> > +		return NF_DROP;
> > +
> >  	if (arp_hdr(skb)->ar_pln != 4) {
> 
> Thats indeed the only location where we call NFPROTO_ARP hooks,
> so this looks like the proper fix/location.

Applied, thanks Eric, and thanks Florian for reviewing.
