Return-Path: <SRS0=tJPO=5V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCB0C2BA15
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 20:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C650020672
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Apr 2020 20:05:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgDEUF2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Apr 2020 16:05:28 -0400
Received: from correo.us.es ([193.147.175.20]:38064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726678AbgDEUF2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Apr 2020 16:05:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 17D9C8140F
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2020 22:05:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 072DBDA736
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Apr 2020 22:05:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EFAF5100A52; Sun,  5 Apr 2020 22:05:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9ED59DA736;
        Sun,  5 Apr 2020 22:05:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 05 Apr 2020 22:05:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 74D3F426CCB9;
        Sun,  5 Apr 2020 22:05:22 +0200 (CEST)
Date:   Sun, 5 Apr 2020 22:05:22 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        Manoj Basapathi <manojbm@codeaurora.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
Message-ID: <20200405200522.5pcxitjcnxss4e7r@salvia>
References: <20200331163559.132240-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="dmv5ja26wlrpku2e"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200331163559.132240-1-zenczykowski@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--dmv5ja26wlrpku2e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi Maciej,

On Tue, Mar 31, 2020 at 09:35:59AM -0700, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
[...]
> We immediately notice that these two rev 1 structs are the
> same size and layout, and that while timer_type and send_nl_msg
> are differently named and serve a different purpose, they're
> at the same offset.

I'm attaching a new version, including EOPNOTSUPP if the send_nl_msg
field is set, it's the most basic handling I can think of until this
option becomes useful.

Would you commit to send a patch for this new merge window to make it
useful?

Thank you.

--dmv5ja26wlrpku2e
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-netfilter-IDLETIMER-target-v1-match-Android-layout.patch"
Content-Transfer-Encoding: 8bit

From f29c2a23ac49126886a2248e5948a8c62888e3dc Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>
Date: Tue, 31 Mar 2020 09:35:59 -0700
Subject: [PATCH] netfilter: IDLETIMER target v1 - match Android layout
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Android has long had an extension to IDLETIMER to send netlink
messages to userspace, see:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/include/uapi/linux/netfilter/xt_IDLETIMER.h#42
Note: this is idletimer target rev 1, there is no rev 0 in
the Android common kernel sources, see registration at:
  https://android.googlesource.com/kernel/common/+/refs/heads/android-mainline/net/netfilter/xt_IDLETIMER.c#483

When we compare that to upstream's new idletimer target rev 1:
  https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git/tree/include/uapi/linux/netfilter/xt_IDLETIMER.h#n46

We immediately notice that these two rev 1 structs are the
same size and layout, and that while timer_type and send_nl_msg
are differently named and serve a different purpose, they're
at the same offset.

This makes them impossible to tell apart - and thus one cannot
know in a mixed Android/vanilla environment whether one means
timer_type or send_nl_msg.

Since this is iptables/netfilter uapi it introduces a problem
between iptables (vanilla vs Android) userspace and kernel
(vanilla vs Android) if the two don't match each other.

Additionally when at some point in the future Android picks up
5.7+ it's not at all clear how to resolve the resulting merge
conflict.

Furthermore, since upgrading the kernel on old Android phones
is pretty much impossible there does not seem to be an easy way
out of this predicament.

The only thing I've been able to come up with is some super
disgusting kernel version >= 5.7 check in the iptables binary
to flip between different struct layouts.

By adding a dummy field to the vanilla Linux kernel header file
we can force the two structs to be compatible with each other.

Long term I think I would like to deprecate send_nl_msg out of
Android entirely, but I haven't quite been able to figure out
exactly how we depend on it.  It seems to be very similar to
sysfs notifications but with some extra info.

Currently it's actually always enabled whenever Android uses
the IDLETIMER target, so we could also probably entirely
remove it from the uapi in favour of just always enabling it,
but again we can't upgrade old kernels already in the field.

(Also note that this doesn't change the structure's size,
as it is simply fitting into the pre-existing padding, and
that since 5.7 hasn't been released yet, there's still time
to make this uapi visible change)

Cc: Manoj Basapathi <manojbm@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/xt_IDLETIMER.h | 1 +
 net/netfilter/xt_IDLETIMER.c                | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter/xt_IDLETIMER.h b/include/uapi/linux/netfilter/xt_IDLETIMER.h
index 434e6506abaa..49ddcdc61c09 100644
--- a/include/uapi/linux/netfilter/xt_IDLETIMER.h
+++ b/include/uapi/linux/netfilter/xt_IDLETIMER.h
@@ -48,6 +48,7 @@ struct idletimer_tg_info_v1 {
 
 	char label[MAX_IDLETIMER_LABEL_SIZE];
 
+	__u8 send_nl_msg;   /* unused: for compatibility with Android */
 	__u8 timer_type;
 
 	/* for kernel module internal use only */
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
index 75bd0e5dd312..7b2f359bfce4 100644
--- a/net/netfilter/xt_IDLETIMER.c
+++ b/net/netfilter/xt_IDLETIMER.c
@@ -346,6 +346,9 @@ static int idletimer_tg_checkentry_v1(const struct xt_tgchk_param *par)
 
 	pr_debug("checkentry targinfo%s\n", info->label);
 
+	if (info->send_nl_msg)
+		return -EOPNOTSUPP;
+
 	ret = idletimer_tg_helper((struct idletimer_tg_info *)info);
 	if(ret < 0)
 	{
-- 
2.11.0


--dmv5ja26wlrpku2e--
