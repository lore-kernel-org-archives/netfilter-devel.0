Return-Path: <SRS0=Pnh4=S5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE33AC43218
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B16EE2054F
	for <netfilter-devel@archiver.kernel.org>; Sat, 27 Apr 2019 09:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfD0Jn2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 27 Apr 2019 05:43:28 -0400
Received: from mail.us.es ([193.147.175.20]:44224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725902AbfD0Jn2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 27 Apr 2019 05:43:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B1E6EC5147
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 11:43:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A0B4EDA701
        for <netfilter-devel@vger.kernel.org>; Sat, 27 Apr 2019 11:43:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9657ADA705; Sat, 27 Apr 2019 11:43:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AA4C6DA701;
        Sat, 27 Apr 2019 11:43:23 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 27 Apr 2019 11:43:23 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 87BA24265A31;
        Sat, 27 Apr 2019 11:43:23 +0200 (CEST)
Date:   Sat, 27 Apr 2019 11:43:23 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mojtaba <mespio@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
Message-ID: <20190427094323.enhkqeoeow4jgmlk@salvia>
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia>
 <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
 <20190426193732.xk3aektc7fb4eg2h@salvia>
 <CABVi_Ex1KoK22m6cKsnCLaTC1gaFSUqX2a54m3H=dm8DZ9NFFQ@mail.gmail.com>
 <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABVi_ExHXzWui4g9YZUx2PdnXXfc-OPv_UY++0rvy3ymurki5w@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 27, 2019 at 01:31:40PM +0430, Mojtaba wrote:
> Hello Pablo,
> Just as better understanding, If i want to update using -U option, How
> can i do that?
> Suppose there is this rule in conntrack row:
> udp      17 29 src=192.168.122.242 dst=192.168.122.103 sport=5070
> dport=5005 [UNREPLIED] src=192.168.122.103 dst=192.168.122.242
> sport=5005 dport
> =5070 mark=0 use=1
>
> and i want to update it with this command:
> conntrack -U -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> --dport 5005 --dst-nat 192.168.122.1:1111 --src-nat
> 192.168.122.103:2222 --timeout 30
> Actually it was not updated and this issue was raised:
> conntrack v1.4.2 (conntrack-tools): 0 flow entries have been updated.

You cannot update an existing entry with NATs.

You can probably make your own libnetfilter_queue application that
allows you to create conntrack entries from packets. If you want to do
custom NAT handling some certain traffic. You will only need to pass
the first packet of the flow to userspace to set up the NAT mangling
you need.

I would need to learn more on your usecase for this.
