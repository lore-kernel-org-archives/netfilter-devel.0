Return-Path: <SRS0=OoQ/=S4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2CFC43219
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:37:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88A2420679
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Apr 2019 19:37:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfDZThi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Apr 2019 15:37:38 -0400
Received: from mail.us.es ([193.147.175.20]:37636 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbfDZThh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Apr 2019 15:37:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 65C0111ED85
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:37:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 558A3DA704
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Apr 2019 21:37:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 48C08DA702; Fri, 26 Apr 2019 21:37:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56705DA704;
        Fri, 26 Apr 2019 21:37:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 26 Apr 2019 21:37:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 361004265A31;
        Fri, 26 Apr 2019 21:37:33 +0200 (CEST)
Date:   Fri, 26 Apr 2019 21:37:32 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mojtaba <mespio@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Issue related to conntrack while insert new rule with conntrack
 command in linux
Message-ID: <20190426193732.xk3aektc7fb4eg2h@salvia>
References: <CABVi_ExMwpQHT57x_tv-1fx2kUgGBfy+k2R-Fbrbki=V-igwrw@mail.gmail.com>
 <CABVi_EwUrvJtE_iXodFXXVn5uqaVjh9fx1qFFqz5fCaLZiE28w@mail.gmail.com>
 <20190425224512.dz2fuwqrrq5hd2x6@salvia>
 <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVi_EwbDf_tA8KdXU33nLgVdHpXNYPtqHGb5DadcL0tdVXAfQ@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 26, 2019 at 11:53:29PM +0430, Mojtaba wrote:
> Thanks again, It works correctly now. But how can i set  port 1111? I
> have just tried like this command but i don’t work and i don't get any
> packets on port 1111 in 192.168.122.1:
> conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070
> --dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30
> 
> The packets that i got  on 192.168.122.1 are either port 5070 or port
> 5005 like below:
> 23:33:38.520746 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, length 12
> 23:33:38.528807 IP 192.168.122.242.5070 > 192.168.122.103.5005: UDP, length 12
> 
>  Actually i would like get packet on 192.168.122.1 on port 1111 like
> this. If i set the two rule of iptables in nat table, i could see the
> packet on 192.168.122.1 like below,too
> 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, length 12
> 23:33:38.528807 IP 192.168.122.103.2222 > 192.168.122.1.1111: UDP, length 12
> 
> So how can i set --src-nat to 192.168.122.103 and port 2222, too?

Does this work?

conntrack -I -p udp -s 192.168.122.242 -d 192.168.122.103 --sport 5070 --dport 5005 --dst-nat 192.168.122.1:1234 --timeout 30
