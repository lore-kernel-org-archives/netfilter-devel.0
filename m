Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A545C25B48
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Oct 2023 08:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344853AbjJZIyo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Oct 2023 04:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234983AbjJZIyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2023 04:54:31 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1631712
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Oct 2023 01:54:07 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 4600F587264C0; Thu, 26 Oct 2023 10:54:05 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 4391A60C28BB6;
        Thu, 26 Oct 2023 10:54:05 +0200 (CEST)
Date:   Thu, 26 Oct 2023 10:54:05 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Phil Sutter <phil@nwl.cc>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/6] man: encode minushyphen the way groff/man requires
 it
In-Reply-To: <ZTf4aLqaO9Zma7lZ@orbyte.nwl.cc>
Message-ID: <0q464op6-5rqq-513p-6427-09q4sqr1230n@vanv.qr>
References: <20231024131919.28665-1-jengelh@inai.de> <ZTf4aLqaO9Zma7lZ@orbyte.nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2023-10-24 19:01, Phil Sutter wrote:
>
>After applying them, I checked the remaining unescaped dashes in man
>pages and found a few spots you missed. Could you please review the
>attached series and incorporate into yours as you see fit?

>6/15 extensions: TRACE: Put commands in bold font

https://marc.info/?l=netfilter-devel&m=169097581506392&w=2

>15/15 extensions: time: Escape dash in time strings
>14/15 extensions: *.man: Escape dash in version strings

I know of no typographic basis that dates should _not_ be expressed
with the normal regular hyphen.

>13/15 extensions: SYNPROXY: Drop linebreaks from example
>7/15 extensions: {S,D}NPT: Properly format examples
> [use .EX command]

I also have to reject this. You are disabling linebreaking, which
just causes text to run off. It's complicated:

* In PostScript & PDF (`man -t -l iptables-extensions.8 >1.ps &&
  ps2pdf 1.ps`):
  text runs off the page and the rest just vanishes

* In HTML: it depends on additional style properties emitted into the
  HTML page by the; in any case, browsers won't wrap <pre> and let
  text equally run off when emitting to a printer. Emitting to a
  display can work (infinitely-sized page), but you have to scroll right.

* In terminals: it depends on the terminal's wrap setting. You can
  try this yourself: use Ctrl-A-R in GNU screen and type a really long
  command.

>11/15 extensions: *.man: Use U+002D dash for ranges and math terms

Number ranges should use an en dash. I fixed that now..
