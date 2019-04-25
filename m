Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 205C0C43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 22:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BFF62067C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 22:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbfDYWpR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 18:45:17 -0400
Received: from mail.us.es ([193.147.175.20]:37802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbfDYWpR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 18:45:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AA662E5A45
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 00:45:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A9BCDA704
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 00:45:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 90302DA702; Fri, 26 Apr 2019 00:45:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E3FDDA704;
        Fri, 26 Apr 2019 00:45:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 00:45:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7D4464265A31;
        Fri, 26 Apr 2019 00:45:12 +0200 (CEST)
Date:   Fri, 26 Apr 2019 00:45:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mojtaba <mespio@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
Message-ID: <20190425224512.dz2fuwqrrq5hd2x6@salvia>
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 25, 2019 at 07:38:20PM +0430, Mojtaba wrote:
> Hello all
> I read man conntrack document guide. That is great.
> I have a issue while i am working on it. For example i just want to insert
> new rule in conntrack table like this:
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> --dport 5005 -r 192.168.122.1 -q 192.168.122.103 --reply-port-src 1111
> --reply-port-dst 2222 --timeout 30
> 
> it successfully inserted but doesn’t work and traffic will be go to INPUT chain.
> if i insert these two rules in iptables, the same above rules will be inserted
> in conntrack table automatically and works correctly.(the traffic will
> be traversed to 192.168.122.1 host)
> iptables -t nat -A PREROUTING -i eth0 -p udp -s 192.168.122.242
> --dport 5005 -j DNAT --to 192.168.122.1:1111
> 
> iptables -t nat -A POSTROUTING -p udp --dport 1111 -j SNAT --to
> 192.168.122.103:2222

Have a look at --dst-nat option, eg.

conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 --dport 5005 --dst-nat 192.168.122.1 --timeout 30
