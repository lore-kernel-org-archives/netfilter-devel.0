Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB14C2D0E5
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87E622073E
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:00:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgCZOAD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:00:03 -0400
Received: from correo.us.es ([193.147.175.20]:49990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgCZOAD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:00:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9E21911EB38
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:00:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8FE08DA840
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:00:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 81BB3DA3A4; Thu, 26 Mar 2020 15:00:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95941DA72F;
        Thu, 26 Mar 2020 14:59:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 14:59:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7129B42EF4E0;
        Thu, 26 Mar 2020 14:59:59 +0100 (CET)
Date:   Thu, 26 Mar 2020 14:59:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Chenbo Feng <fengc@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH] iptables: open eBPF programs in read only mode
Message-ID: <20200326135959.tqy5i4qkxwcqgp5y@salvia>
References: <20200320030015.195806-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200320030015.195806-1-zenczykowski@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 19, 2020 at 08:00:15PM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> Adjust the mode eBPF programs are opened in so 0400 pinned bpf programs
> work without requiring CAP_DAC_OVERRIDE.

Unfortunately this is breaking stuff:

libxt_bpf.c: In function ‘bpf_obj_get_readonly’:
libxt_bpf.c:70:6: error: ‘union bpf_attr’ has no member named ‘file_flags’
   70 |  attr.file_flags = BPF_F_RDONLY;
      |      ^
libxt_bpf.c:70:20: error: ‘BPF_F_RDONLY’ undeclared (first use in this function)
   70 |  attr.file_flags = BPF_F_RDONLY;
      |                    ^~~~~~~~~~~~
