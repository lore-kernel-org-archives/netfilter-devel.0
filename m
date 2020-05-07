Return-Path: <SRS0=DUCC=6V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE9A4C38A24
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 11:30:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9A4020CC7
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 May 2020 11:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgEGLab (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 May 2020 07:30:31 -0400
Received: from correo.us.es ([193.147.175.20]:50822 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgEGLaa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 May 2020 07:30:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC75B154E82
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 13:30:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BE8C6115417
        for <netfilter-devel@vger.kernel.org>; Thu,  7 May 2020 13:30:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3762115412; Thu,  7 May 2020 13:30:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B34F8E619;
        Thu,  7 May 2020 13:30:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 May 2020 13:30:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7065842EF4E1;
        Thu,  7 May 2020 13:30:27 +0200 (CEST)
Date:   Thu, 7 May 2020 13:30:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Subject: Re: nft: crash parsing cmd line
Message-ID: <20200507113027.GB31995@salvia>
References: <nycvar.YFH.7.76.2005070913540.15894@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nycvar.YFH.7.76.2005070913540.15894@n3.vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 07, 2020 at 09:16:22AM +0200, Jan Engelhardt wrote:
> 
> It was reported via                                                                                                                                
> http://bugzilla.opensuse.org/show_bug.cgi?id=1171321                                                                            
> that nft exhibits a crash parsing the command line. This problem still 
> exists as of 93eeceb50078e6ca54636017ee843cbeffbb4179.
> 
> » nft add rule inet traffic-filter input tcp dport { 22, 80, 443 } accept

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200507112919.21227-1-pablo@netfilter.org/

Thanks for reporting.
