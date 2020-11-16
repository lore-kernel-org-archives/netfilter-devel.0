Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5048EC55ABD
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 06:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 033DE2222E
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 06:33:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="FmRZu3cP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgKPGcJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 01:32:09 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:27356 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726898AbgKPGcI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 01:32:08 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605508328; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=XWNcUq154jgRoEak0j3R0KCbD4xxlg8GNLM2hYtND5E=;
 b=FmRZu3cP8TnbPj4M5+91I/sAqwqJfqFgw6T/mBWVIORw1OH/zsfBOK72oLur9TrCoj2y/kLn
 rNcautCpu9+v9vq79t93SfwH2AX9LA7HVIPIzrups+OainYL4M+kVKm4pqCR3qbKqnDRI3Dw
 R0al7ezCEHdgJ3KIOZRM78c7LW4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n09.prod.us-west-2.postgun.com with SMTP id
 5fb21ce7e9dd187f53539a4c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 06:32:07
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 3C078C43460; Mon, 16 Nov 2020 06:32:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85CEEC433C6;
        Mon, 16 Nov 2020 06:32:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 15 Nov 2020 23:32:06 -0700
From:   subashab@codeaurora.org
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
In-Reply-To: <20201114165330.GM23619@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
Message-ID: <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

> I'm fine with this change but AFAIU this is just a cleanup since
> this part isn't a read-sequence as no  'shared state' is accessed/read 
> between
> the seqcount begin and the do{}while. smb_rmb placement should not 
> matter here.
> 
> Did I miss anything?
> 
> Thanks.

Hi Florian

To provide more background on this, we are seeing occasional crashes in 
a
regression rack in the packet receive path where there appear to be
some rules being modified concurrently.

Unable to handle kernel NULL pointer dereference at virtual
address 000000000000008e
pc : ip6t_do_table+0x5d0/0x89c
lr : ip6t_do_table+0x5b8/0x89c
ip6t_do_table+0x5d0/0x89c
ip6table_filter_hook+0x24/0x30
nf_hook_slow+0x84/0x120
ip6_input+0x74/0xe0
ip6_rcv_finish+0x7c/0x128
ipv6_rcv+0xac/0xe4
__netif_receive_skb+0x84/0x17c
process_backlog+0x15c/0x1b8
napi_poll+0x88/0x284
net_rx_action+0xbc/0x23c
__do_softirq+0x20c/0x48c

We found that ip6t_do_table was reading stale values from the READ_ONCE
leading to use after free when dereferencing per CPU jumpstack values.

[https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv6/netfilter/ip6_tables.c?h=v5.4.77#n282]
	addend = xt_write_recseq_begin();
	private = READ_ONCE(table->private); /* Address dependency. */

We were able to confirm that the xt_replace_table & __do_replace
had already executed by logging the seqcount values. The value of
seqcount at ip6t_do_table was 1 more than the value at xt_replace_table.
The seqcount read at xt_replace_table also showed that it was an even 
value
and hence meant that there was no conccurent writer instance 
(xt_write_recseq_begin)
at that point.

[https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/x_tables.c?h=v5.4.77#n1401]
		u32 seq = raw_read_seqcount(s);

This means that table assignment at xt_replace_table did not take effect
as expected.

[https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/x_tables.c?h=v5.4.77#n1386]
	smp_wmb();
	table->private = newinfo;

	/* make sure all cpus see new ->private value */
	smp_wmb();

We want to know if this barrier usage is as expected here.
Alternatively, would changing this help here -

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 525f674..417ea1b 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1431,11 +1431,11 @@ xt_replace_table(struct xt_table *table,
          * Ensure contents of newinfo are visible before assigning to
          * private.
          */
-       smp_wmb();
-       table->private = newinfo;
+       smp_mb();
+       WRITE_ONCE(table->private, newinfo);

         /* make sure all cpus see new ->private value */
-       smp_wmb();
+       smp_mb();

         /*
          * Even though table entries have now been swapped, other CPU's
