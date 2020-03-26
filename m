Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6BAAC2D0E8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:22:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0FD2076A
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgCZOWc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:22:32 -0400
Received: from correo.us.es ([193.147.175.20]:60404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbgCZOWc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:22:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id ECB1281413
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:22:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD5D7DA72F
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:22:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D2BFAFC5E5; Thu, 26 Mar 2020 15:22:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 12A2CDA72F;
        Thu, 26 Mar 2020 15:22:28 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 15:22:28 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E1D5742EF4E0;
        Thu, 26 Mar 2020 15:22:27 +0100 (CET)
Date:   Thu, 26 Mar 2020 15:22:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailinglist 
        <netfilter-devel@vger.kernel.org>, Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
Message-ID: <20200326142227.fclwbiibfjym7l6m@salvia>
References: <20200320030015.195806-1-zenczykowski@gmail.com>
 <20200326135959.tqy5i4qkxwcqgp5y@salvia>
 <CAHo-OoyGEPKdU5ZEuY29Zzi4NGzD-QMw7Pb-MTXjdKTj-Kj-Pw@mail.gmail.com>
 <CAHo-OozGK7ANfFDBnLv2tZVuhXUw1sCCRVTBc0YT7LvYVXH_ZQ@mail.gmail.com>
 <CAHo-Oow8otp4ruAUpvGYjXN_f3dsbprg_DKOGG6HNhe_Z8X8Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHo-Oow8otp4ruAUpvGYjXN_f3dsbprg_DKOGG6HNhe_Z8X8Vg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 26, 2020 at 07:16:16AM -0700, Maciej Żenczykowski wrote:
> I guess maybe we could wrap it in a
> 
> #ifdef BPF_F_RDONLY
> attr.file_flags = BPF_F_RDONLY;
> #endif
> 
> if we want to continue supporting building against pre-4.15 kernel headers...

You can probably add a cached copy of this header file to the iptables
tree via your patch like. This is done in other existing extensions to
not rely on the available kernel headers.

There is no parity between userspace iptables and kernel version, it
is good if you make sure this compiles for older kernels are still
supported.

Thank you.
