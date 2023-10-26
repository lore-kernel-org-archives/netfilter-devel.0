Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34049C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 13:42:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjJZNm2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 09:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbjJZNm1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 09:42:27 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B98418A
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 06:42:25 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 771F55890750B; Thu, 26 Oct 2023 15:42:23 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 74CAD60DBEC17;
        Thu, 26 Oct 2023 15:42:23 +0200 (CEST)
Date:   Thu, 26 Oct 2023 15:42:23 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 09/10] man: use .TP for lists in xt_osf man page
In-Reply-To: <ZTpa/DM6DyxywkWL@orbyte.nwl.cc>
Message-ID: <n5qnp222-6p4s-r2p4-p6oq-0s1n4qq5496n@vanv.qr>
References: <20231026085506.94343-1-jengelh@inai.de> <20231026085506.94343-9-jengelh@inai.de> <ZTpa/DM6DyxywkWL@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Thursday 2023-10-26 14:26, Phil Sutter wrote:
>> @@ -8,24 +8,34 @@ Match an operating system genre by using a passive fingerprinting.
>>  \fB\-\-ttl\fP \fIlevel\fP
>>  Do additional TTL checks on the packet to determine the operating system.
>>  \fIlevel\fP can be one of the following values:
>> -.IP \(bu 4
>> -0 - True IP address and fingerprint TTL comparison. This generally works for
>> +.RS
>> +.TP
>> +\fB0\fP
>
>What is wrong with '.B' here? I assumed it is equivalent to the escapes
>(which I don't like for making things unreadable in most cases).

One can make lots of arguments for both sides.

* You cannot mix certain commands. This for example cannot be
  converted to use .B syntax as far as my understanding of roff
  syntax goes:

	.TP
	Some \fBbold\fP keyword
	Explanation what they keyword does

	.TP
	Some
	.B bold
	keyword but oops we are already in the explanation

* Desire for consistent markup across entire documentation;
  since we cannot use .B reliably, \fB offered to take the
  place and so almost all the mantext in iptables uses \fB.

* .B (and commands like it) bloat the line count if you have a lot of
  words to markup, and we certainly do in e.g. the "Synopsis"
  sections.

* \(en could be changed to \[en] or to the Unicode character
  directly. But the groff manpage has ample warnings:

  """these groff extensions are presented using its special character
  form \[]"""

  """Some of these code points are used by groff for internal
  purposes, which is one reason it does not support UTF‐8
  natively."""

  I need to revise the \[-] patch perhaps based on what I just
  learned.

That said, it's 2023. People _should_ be having a syntax-highlighting
editor, and I don't mean it needs to have fancy colors. Just set
escape codes apart (brighten or dimming, whichever is your thing),
e.g. https://paste.opensuse.org/pastes/b593dd7ee4db .
