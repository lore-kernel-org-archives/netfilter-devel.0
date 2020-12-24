Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9EA7C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Dec 2020 13:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8767A22255
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Dec 2020 13:35:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgLXNfz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Dec 2020 08:35:55 -0500
Received: from m43-15.mailgun.net ([69.72.43.15]:53104 "EHLO
        m43-15.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726611AbgLXNfy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Dec 2020 08:35:54 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1608816935; h=Message-ID: Subject: To: From: Date:
 Content-Transfer-Encoding: Content-Type: MIME-Version: Sender;
 bh=aJW7nPK6uL35BHohdPbwc6RXRFw+1PB+pvF8T8N6QvM=; b=ugAPHVfM3vOTBLhCuoidSfndN6WaFoEdQBY+BlKOHoAbwh2ZYvo0rl6TlAY/7MUN2eG38qSV
 09GneUNW0JY8vCGgX4QjuhqMyBuFCMx1fg8+H0Ugi9Tc7QDVfFalzwfiQaCsmjIVSQbYNRWd
 zoYNazG09se7vf7D9J2RZ9LyVOM=
X-Mailgun-Sending-Ip: 69.72.43.15
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 5fe4990c7036173f4f2172f7 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 24 Dec 2020 13:35:08
 GMT
Sender: sharathv=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 81CE5C43461; Thu, 24 Dec 2020 13:35:07 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: sharathv)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C1FADC433C6;
        Thu, 24 Dec 2020 13:35:06 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 24 Dec 2020 19:05:06 +0530
From:   sharathv@codeaurora.org
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: stack corruption with EBT_ENTRY_ITERATE
Message-ID: <225278703b646c7f86aaafd8c9c9cde2@codeaurora.org>
X-Sender: sharathv@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

  Hi All,

  Observing a stack corruption when we are trying to install multiple 
ebtable
  rules on 32-bit arm arch (not tried on 64-bit). An out of bounds access 
is
  observed beyond the virtual memory region that was allocated for 
storing the entries.

  do_replace() {
          newinfo->entries = 
__vmalloc(tmp.entries_size,GFP_KERNEL_ACCOUNT,
                                                PAGE_KERNEL);
                   if (!newinfo->entries) {
                       ret = -ENOMEM;
                       goto free_newinfo;
           }
  }

  This panic is seen when the entries_size is at the boundary of 
PAGE_SIZE (4K).
  If the entries_size is well within limits of 4K, no issues observed.
.
  Through debug prints observed that the entries are clean, but
  strangely when the control returns from EBT_ENTRY_ITERATE code the 
panic is observed.

  Tried changing the macro into a function, assuming that variable args 
being passed
  could have been messing up the stack somehow. To my surprise with fixed
  argument functions issue is no longer observed.

  Can you guys help share inputs to help understand the problem why the 
variable args is
  a problem and not function with fixed args.. Any known issues on 32-bit 
arm architecture
  similar to this?

  Also, I found this change 
https://www.spinics.net/lists/netdev/msg144567.html
  which was submitted but didn't get accepted, could not get the 
discussion details.
  Note that this change also helps resolve the panic issue.

[ 1640.924251] Unable to handle kernel paging request at virtual address 
d7908008
[ 1640.924315] pgd = c2d1c000
[ 1640.938287] [d7908008] *pgd=87e8d811, *pte=00000000, *ppte=00000000
[ 1640.938357] Internal error: Oops: 7 [#1] PREEMPT ARM
[ 1640.967760] CPU: 0 PID: 8398 Comm: ebtables Tainted: G        W  O    
4.14.206 #1
[ 1640.997394] task: c2ce21c0 task.stack: c9028000
[ 1641.005545] PC is at translate_table+0x1c8/0xe54
[ 1641.009882] LR is at 0x19
[ 1641.315119] [<c0c6e6b4>] (translate_table) from [<c0c6fc48>] 
(do_ebt_set_ctl+0x688/0xd2c)
[ 1641.323268] [<c0c6fc48>] (do_ebt_set_ctl) from [<c0b4c1a4>] 
(nf_sockopt+0x124/0x134)
[ 1641.331426] [<c0b4c1a4>] (nf_sockopt) from [<c0b4c068>] 
(nf_setsockopt+0x54/0x6c)
[ 1641.339238] [<c0b4c068>] (nf_setsockopt) from [<c0b9000c>] 
(ip_setsockopt+0xe30/0x1304)
[ 1641.346619] [<c0b9000c>] (ip_setsockopt) from [<c0bb66fc>] 
(raw_setsockopt+0x104/0x11c)
[ 1641.354431] [<c0bb66fc>] (raw_setsockopt) from [<c0af34b0>] 
(sock_common_setsockopt+0x44/0x4c)
[ 1641.362422] [<c0af34b0>] (sock_common_setsockopt) from [<c0aec384>] 
(SyS_setsockopt+0xcc/0x104)
[ 1641.371100] [<c0aec384>] (SyS_setsockopt) from [<c01085a0>] 
(ret_fast_syscall+0x0/0x28)
[ 1641.379691] Code: 1affffa4 e5921000 e3a04000 e592902c (e592206c)
[ 1641.398618] ---[ end trace 0bce651f43449794 ]---

  Regards,
  Sharath
