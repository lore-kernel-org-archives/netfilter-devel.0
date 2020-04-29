Return-Path: <SRS0=4AXv=6N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F987C83007
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B65721D82
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 Apr 2020 19:16:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgD2TQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Apr 2020 15:16:48 -0400
Received: from correo.us.es ([193.147.175.20]:36134 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgD2TQr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Apr 2020 15:16:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 21982D2DA18
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:16:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 132DCDA736
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:16:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08CB3BAAB4; Wed, 29 Apr 2020 21:16:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29D5E20661
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:16:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Apr 2020 21:16:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0D8C942EF9E2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Apr 2020 21:16:44 +0200 (CEST)
Date:   Wed, 29 Apr 2020 21:16:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue 0/3] pktbuff API updates
Message-ID: <20200429191643.GA16749@salvia>
References: <20200426132356.8346-1-pablo@netfilter.org>
 <20200427110614.GA15436@dimstar.local.net>
 <20200427170656.GA22296@salvia>
 <20200428043302.GB15436@dimstar.local.net>
 <20200428103407.GA1160@salvia>
 <20200428211452.GF15436@dimstar.local.net>
 <20200428225520.GA30421@salvia>
 <20200429132840.GA3833@dimstar.local.net>
 <20200429191047.GB3833@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429191047.GB3833@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 05:10:47AM +1000, Duncan Roe wrote:
[...]
> Sorry, I should have explained a bit more how the system would work:
> 
> struct pkt_buff has 3 new members:
> 
>         bool    copy_done;
>         uint32_t extra;
>         uint8_t *copy_buf;
> 
> When extra > 0, pktb_alloc2 verifies that buflen is >= len + extra. It then
> stores extra and copy_buf in pktb, ready for use by pktb_mangle() (all the other
> manglers call this eventually).
> 
> So that's how pktb_mangle() doesn't need to allocate a buffer.

Thanks for the explaining. Given this is in userspace, it is easier if
the user allocates the maximum packet length that is possible:

        0xffff + (MNL_SOCKET_BUFFER_SIZE/2);

We can probably expose this to the header so they can pre-allocate a
buffer that is large enough and, hence, _mangle() is guaranteed to
have always enough room to add extra bytes.
