Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFE7C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 12:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43DB26109D
	for <netfilter-devel@archiver.kernel.org>; Fri, 13 Aug 2021 12:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239092AbhHMMCO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Aug 2021 08:02:14 -0400
Received: from relais-inet.orange.com ([80.12.70.35]:60740 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbhHMMCN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Aug 2021 08:02:13 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Aug 2021 08:02:13 EDT
Received: from opfednr03.francetelecom.fr (unknown [xx.xx.xx.67])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfednr24.francetelecom.fr (ESMTP service) with ESMTPS id 4GmMRk29qJz1y78
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Aug 2021 13:54:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1628855682;
        bh=r5eC+0cVAPjZXzXG0BUhgzHuku5yk94qi6VYdGa4hIs=;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=ryka0KFLsj2VGPqGTE/sppFX87ScCmxYrHsn2Sw1EoGJKIw1jFmbotMvPWP/lr824
         nfOcAN3uCzd9znvPuYs6Ts0tXEacHZ2iO6zqb5N1sfp9fWROLo63lpimAkeOjv0ZeF
         KZmk6bKCwoUZO9g3qqiJis0tuWssDR/kIY1lp1hTRS7s6VYUSvtan+id0DGtfDQ9+e
         bOOQGW38Cj8hI2SU4JVNHFzlxgf0qtWD9j8d3Kgqg/AcM2c2Vu4OUN8mClzhTLFzlq
         s8dY2yNOKK4TJsYDunj9w6vjScApm2T1IKVZOlO2EYXij2CkL+qc7sB+XpT9Rmdo6y
         9ZAVhcppc3Lvg==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfednr03.francetelecom.fr (ESMTP service) with ESMTPS id 4GmMRk1ZrRzDq80
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Aug 2021 13:54:42 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Fri, 13 Aug
 2021 13:54:42 +0200
From:   <alexandre.ferrieux@orange.com>
Subject: nfnetlink_queue -- why linear lookup ?
To:     <netfilter-devel@vger.kernel.org>
Message-ID: <11790_1628855682_61165D82_11790_25_1_3f865faa-9fd8-40aa-6e49-5d85dd596b5b@orange.com>
Date:   Fri, 13 Aug 2021 13:55:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

In nfnetlink_queue.c, when receiving a verdict for a packet, its entry in the 
queue is looked up linearly:

   find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
   {
     ...
     list_for_each_entry(i, &queue->queue_list, list) {
       if (i->id == id) {
         entry = i;
         break;
       }
     }
     ...
   }

As a result, in a situation of "highly asynchronous" verdicts, i.e. when we want 
some packets to linger in the queue for some time before reinjection, the mere 
existence of a large number of such "old packets" may incur a nonnegligible cost 
to the system.

So I'm wondering: why is the list implemented as a simple linked list instead of 
an array directly indexed by the id (like file descriptors) ?

Indeed, the list has a configured max size, the passed id can be bound-checked, 
discarded entries can simply hold a NULL, and id reuse is userspace's 
responsibility. So it looks like the array would yield constant-time lookup with 
no extra risk.

What am I missing ?

Thans in advance,

-Alex

_________________________________________________________________________________________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confidentielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages electroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou falsifie. Merci.

This message and its attachments may contain confidential or privileged information that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and delete this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been modified, changed or falsified.
Thank you.

