Return-Path: <SRS0=uHYT=BB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1F06C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 22:48:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBCFD2086A
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jul 2020 22:48:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbgGVWs0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 18:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgGVWsZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 18:48:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD098C0619DC;
        Wed, 22 Jul 2020 15:48:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 34A3511E8DD83;
        Wed, 22 Jul 2020 15:31:39 -0700 (PDT)
Date:   Wed, 22 Jul 2020 15:48:20 -0700 (PDT)
Message-Id: <20200722.154820.1749937838006185071.davem@davemloft.net>
To:     netdev@vger.kernel.org
CC:     linux-wireless@vger.kernel.org, netfilter-devel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org, lwn@lwn.net
Subject: LPC 2020 Networking and BPF Track CFP (Reminder)
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jul 2020 15:31:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


[ The deadline is a week and a half away, please get your submissions
  in soon! ]

This is a reminder for the call for proposals for the networking and
bpf track at the Linux Plumbers Conference on the wider internet,
which will be happening on August 24th-28th, 2020.

This year the technical committee is comprised of:

David S. Miller <davem@davemloft.net>
Alexei Starovoitov <ast@kernel.org>
Daniel Borkmann <daniel@iogearbox.net>
Jakub Sitnicki <jakub@cloudflare.com>
Paolo Abeni <pabeni@redhat.com>
Jakub Kicinski <kuba@kernel.org>
Michal Kubecek <mkubecek@suse.cz>
Sabrina Dubroca <sd@queasysnail.net>

We are seeking talks of 40 minutes in length (including Q & A),
optionally accompanied by papers of 2 to 10 pages in length.  The
papers, while not required, are very strongly encouraged by the
committee.  The submitters intention to provide a paper will be taken
into consideration as a criteria when deciding which proposals to
accept.

Any kind of advanced networking and/or bpf related topic will be
considered.

Please submit your proposals on the LPC website at:

	https://www.linuxplumbersconf.org/event/7/abstracts/#submit-abstract

And be sure to select "Networking & BPF Summit" in the Track
pulldown menu.

Proposals must be submitted by August 2nd, and submitters will be
notified of acceptance by August 9th.

Final slides and papers (as PDF) are due on August 24th, the first day of
the conference.
