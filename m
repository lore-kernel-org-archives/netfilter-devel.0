Return-Path: <SRS0=MWc4=UA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8116DC04AB6
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 00:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4710E27063
	for <netfilter-devel@archiver.kernel.org>; Sat,  1 Jun 2019 00:12:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbfFAAMN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 May 2019 20:12:13 -0400
Received: from mail.us.es ([193.147.175.20]:39814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfFAAMM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 May 2019 20:12:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 583EEE2D9A
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 02:12:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 48D1BDA703
        for <netfilter-devel@vger.kernel.org>; Sat,  1 Jun 2019 02:12:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3E7F7DA701; Sat,  1 Jun 2019 02:12:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A39FBDA703;
        Sat,  1 Jun 2019 02:12:06 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 01 Jun 2019 02:12:06 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 82AE44265A31;
        Sat,  1 Jun 2019 02:12:06 +0200 (CEST)
Date:   Sat, 1 Jun 2019 02:12:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Kernel compilation error
Message-ID: <20190601001205.t4rj4x4pe27secbz@salvia>
References: <a4fc9076-f051-9dc6-90d5-f62d70d74068@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a4fc9076-f051-9dc6-90d5-f62d70d74068@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, May 31, 2019 at 10:44:58PM +0200, Fernando Fernandez Mancera wrote:
> Hi,
> 
> I am getting the following error when compiling the kernel after pull
> the last changes from nf-next.git.
> 
> >   CC      security/apparmor/lsm.o
> >   CC      kernel/trace/trace_stack.o
> > In file included from security/apparmor/lsm.c:27:
> > ./include/linux/netfilter_ipv6.h: In function ‘nf_ipv6_br_defrag’:
> > ./include/linux/netfilter_ipv6.h:113:9: error: implicit declaration of function ‘nf_ct_frag6_gather’; did you mean ‘nf_ct_attach’? [-Werror=implicit-function-declaration]
> >   return nf_ct_frag6_gather(net, skb, user);
> >          ^~~~~~~~~~~~~~~~~~
> >          nf_ct_attach
> >   CC [M]  arch/x86/kvm/mmu.o
> 
> I have been taking a loook into .config for any missing module but I
> didn't find anything wrong. Is this a known issue? Thanks!

http://patchwork.ozlabs.org/patch/1108256/
