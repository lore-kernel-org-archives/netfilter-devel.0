Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8691C001DE
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 08:38:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbjHBIij (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbjHBIih (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 04:38:37 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44B8BA8
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 01:38:36 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id E53C85872FA7C; Wed,  2 Aug 2023 10:38:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id E444260C29143;
        Wed,  2 Aug 2023 10:38:34 +0200 (CEST)
Date:   Wed, 2 Aug 2023 10:38:34 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org, debian@helgefjell.de
Subject: Re: [iptables PATCH 07/16] man: iptables-restore.8: Fix --modprobe
 description
In-Reply-To: <20230802020400.28220-8-phil@nwl.cc>
Message-ID: <s45p40on-4875-5o29-sppr-qn92873q4p02@vanv.qr>
References: <20230802020400.28220-1-phil@nwl.cc> <20230802020400.28220-8-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2023-08-02 04:03, Phil Sutter wrote:

>- Consistently use 'modprobe' as option argument name
>- Add a reference to modprobe man page
>- Put the path in italics, and the command in bold
>
>Reported-by: debian@helgefjell.de
>Fixes: 8c46901ff5785 ("doc: document iptables-restore's -M option")
>Signed-off-by: Phil Sutter <phil@nwl.cc>
>---
> iptables/iptables-restore.8.in | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/iptables/iptables-restore.8.in b/iptables/iptables-restore.8.in
>index 20216842d8358..5846a47cefbcc 100644
>--- a/iptables/iptables-restore.8.in
>+++ b/iptables/iptables-restore.8.in
>@@ -67,9 +67,10 @@ the program will exit if the lock cannot be obtained.  This option will
> make the program wait (indefinitely or for optional \fIseconds\fP) until
> the exclusive lock can be obtained.
> .TP
>-\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe_program\fP
>-Specify the path to the modprobe program. By default, iptables-restore will
>-inspect /proc/sys/kernel/modprobe to determine the executable's path.
>+\fB\-M\fP, \fB\-\-modprobe\fP \fImodprobe\fP
>+Specify the path to the \fBmodprobe\fP(8) program. By default,
>+\fBiptables-restore\fP will inspect \fI/proc/sys/kernel/modprobe\fP to
>+determine the executable's path.

Same \fB..\fP counterargument as for patch 6/16.
