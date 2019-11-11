Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1E9C43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 20:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB7AE20659
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 20:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="la4Bg5aK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="la4Bg5aK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKKUtf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 15:49:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33516 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbfKKUtf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 15:49:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BA0AC60EE1; Mon, 11 Nov 2019 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573505370;
        bh=EBHvRH3n0iOP2H7nxj5JooMMxvS6eLub5rnW3cp1lhA=;
        h=Date:From:To:Cc:Subject:From;
        b=la4Bg5aKTkbkIMlB1iqsxgOBkohsqcyyZv3mYR8egVzkCooVgHD0h+8i5yCo1YTJr
         lRe7MsTmLv1hrtHVuqd/alvNU1yZh53LK5bat30dAzojvfvY9WMMor8L16TdfuLih1
         8V7xe+3DUY9ZMf9wGIQysl6NqDETQ9F9IZXx+bZ0=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 0E46460DE9;
        Mon, 11 Nov 2019 20:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573505370;
        bh=EBHvRH3n0iOP2H7nxj5JooMMxvS6eLub5rnW3cp1lhA=;
        h=Date:From:To:Cc:Subject:From;
        b=la4Bg5aKTkbkIMlB1iqsxgOBkohsqcyyZv3mYR8egVzkCooVgHD0h+8i5yCo1YTJr
         lRe7MsTmLv1hrtHVuqd/alvNU1yZh53LK5bat30dAzojvfvY9WMMor8L16TdfuLih1
         8V7xe+3DUY9ZMf9wGIQysl6NqDETQ9F9IZXx+bZ0=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 11 Nov 2019 13:49:30 -0700
From:   stranche@codeaurora.org
To:     fw@strlen.de, netfilter-devel@vger.kernel.org
Cc:     Subashab <subashab@codeaurora.org>
Subject: UAF in ip6_do_table on 4.19 kernel
Message-ID: <e7501cbd85e96b111f5c404200a3a330@codeaurora.org>
X-Sender: stranche@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

We recently had a crash reported to us on the 4.19 kernel where 
ip6_do_table() appeared to be referencing a jumpstack that had already 
been freed.
Based on the dump, it appears that the scenario was a concurrent use of 
iptables-restore and active data transfer. The kernel has Florian's 
commit
to wait in xt_replace_table instead of get_counters(), 80055dab5de0 
("netfilter: x_tables: make xt_replace_table wait until old rules are 
not used
anymore"), so it appears that xt_replace_table is somehow returning 
prematurely, allowing __do_replace() to free the table while it is still 
in use.

After reviewing the code, we had a question about the following section:
	/* ... so wait for even xt_recseq on all cpus */
	for_each_possible_cpu(cpu) {
		seqcount_t *s = &per_cpu(xt_recseq, cpu);
		u32 seq = raw_read_seqcount(s);

		if (seq & 1) {
			do {
				cond_resched();
				cpu_relax();
			} while (seq == raw_read_seqcount(s));
		}
	}

Based on the other uses of seqcount locks, there should be a paired 
read_seqcount_retry() to mark the end of the read section like below:
	for_each_possible_cpu(cpu) {
		seqcount_t *s = &per_cpu(xt_recseq, cpu);
		u32 seq;

		do {
			seq = raw_read_seqcount(s);
			if (seq & 1) {
				cond_resched();
				cpu_relax();
			}
		} while (read_seqcount_retry(s, seq);
	}

These two snippets are very similar, as the original seems like it 
attempted to open-code this retry() helper, but there is a slight 
difference in
the smp_rmb() placement relative to the "retry" read of the sequence 
value.
Original:
	READ_ONCE(s->sequence);
	smp_rmb();
	... //check and resched
	READ_ONCE(s->sequence);
	smp_rmb();
	... //compare the two sequence values

Modified using read_seqcount_retry():
	READ_ONCE(s->sequence);
	smp_rmb();
	... //check and and resched
	smp_rmb();
	READ_ONCE(s->sequence);
	... //compare the two sequence values

Is it possible that this difference in ordering could lead to an 
incorrect read of the sequence in certain neurotic scenarios? 
Alternatively, is there
some other place that this jumpstack could be freed while still in use?

Thanks,
Sean

---
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora 
Forum,
a Linux Foundation Collaborative Project
