Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58561C04A94
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 08:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjHBIh6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 04:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjHBIhz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 04:37:55 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F07A8
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 01:37:54 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 07DF35872FA13; Wed,  2 Aug 2023 10:37:53 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 0602960C29143;
        Wed,  2 Aug 2023 10:37:53 +0200 (CEST)
Date:   Wed, 2 Aug 2023 10:37:53 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org, debian@helgefjell.de
Subject: Re: [iptables PATCH 06/16] man: iptables.8: Trivial font fixes
In-Reply-To: <20230802020400.28220-7-phil@nwl.cc>
Message-ID: <7n662o78-97qr-25n8-130s-prp6rp35n1r0@vanv.qr>
References: <20230802020400.28220-1-phil@nwl.cc> <20230802020400.28220-7-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Wednesday 2023-08-02 04:03, Phil Sutter wrote:

>No content changes intended, just type commands in bold and the single
>path reference in italics.
>
>diff --git a/iptables/iptables.8.in b/iptables/iptables.8.in
>index 71a6251d6b00c..5a9cec6c9eb35 100644
>--- a/iptables/iptables.8.in
>+++ b/iptables/iptables.8.in
>@@ -200,7 +200,7 @@ or
> .TP
> \fB\-S\fP, \fB\-\-list\-rules\fP [\fIchain\fP]
> Print all rules in the selected chain.  If no chain is selected, all
>-chains are printed like iptables-save. Like every other iptables command,
>+chains are printed like \fBiptables-save\fP. Like every other iptables command,
> it applies to the specified table (filter is the default).

Lacking different markup options, I used bold for things you type verbatim
(would use <tt></tt> in HTML or `` in MD/RST), and italics for replacables.

In that instance,
	...printed like iptables-save.
was meant to indeed read like a name, i.e.
	...printed like iptables-save(8).
not like a command, i.e.
	...printed like `iptables-save`.

(Also note that ifff you did \fBiptables-save\fP, it would have need to be
\fBiptables\-save\fP, because that is required for verbatim forms.)

The same argument goes for all the rest:

>@@ -242,30 +242,30 @@ The following parameters make up a rule specification (as used in the
> add, delete, insert, replace and append commands).
> .TP
> \fB\-4\fP, \fB\-\-ipv4\fP
>-This option has no effect in iptables and iptables-restore.
>+This option has no effect in \fBiptables\fP and \fBiptables-restore\fP.
> If a rule using the \fB\-4\fP option is inserted with (and only with)
>-ip6tables-restore, it will be silently ignored. Any other uses will throw an
>+\fBip6tables-restore\fP, it will be silently ignored. Any other uses will throw an
...
