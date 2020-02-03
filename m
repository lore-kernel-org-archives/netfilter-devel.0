Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D67DFC35247
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B558C20838
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 16:44:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgBCQoQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 11:44:16 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:41800 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730315AbgBCQby (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 11:31:54 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iyedc-0008UT-Fs; Mon, 03 Feb 2020 17:31:52 +0100
Date:   Mon, 3 Feb 2020 17:31:52 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     dyslexicatheist <dyslexicatheist@protonmail.com>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: invalid read in
Message-ID: <20200203163152.GY19873@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        dyslexicatheist <dyslexicatheist@protonmail.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
References: <gwRjoIGUgI5MEgxSob7CBSUwPbYkxILRc4_ZrYWYNI7d1-T5Ej95p3XkEY_f9hLqHK5nVun7dk6RqObi0c_4482IJ6s6U33PyS6Hrm4z46E=@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gwRjoIGUgI5MEgxSob7CBSUwPbYkxILRc4_ZrYWYNI7d1-T5Ej95p3XkEY_f9hLqHK5nVun7dk6RqObi0c_4482IJ6s6U33PyS6Hrm4z46E=@protonmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Feb 03, 2020 at 01:54:31PM +0000, dyslexicatheist wrote:
> I've written a filter to parse out punicode from DNS payloads and rewrite the packet in case it contains any IDN (xn--) marker unless the IDN is on a whitelist. Valgrind reports that nfq_create_queue() returns uninitialized
> bytes resulting in thiserror:
> 
> 
> sudo valgrind --tool=memcheck --leak-check=yes --show-reachable=yes \
>            --num-callers=20 --track-fds=yes --track-origins=yes -s \
>             ./nfq --syslog --facility LOG_LOCAL0 --log-level info \
>                   --port 53  --renice -20 --rewrite-answer
>       ==714384==
>       ==714384== Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
>       ==714384==    at 0x4B977C7: sendto (sendto.c:27)
>       ==714384==    by 0x486BE02: nfnl_send (in /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0)
>       ==714384==    by 0x486DBD2: nfnl_query (in /usr/lib/x86_64-linux-gnu/libnfnetlink.so.0.2.0)
>       ==714384==    by 0x4A73995: nfq_set_mode (libnetfilter_queue.c:639)
>       ==714384==    by 0x10B247: start_nfqueue_processing (nfq.c:532)
>       ==714384==    by 0x10C289: main (nfq.c:987)
>       ==714384==  Address 0x1ffefefbfd is on thread 1's stack
>       ==714384==  in frame #3, created by nfq_set_mode (libnetfilter_queue.c:623)
>       ==714384==  Uninitialised value was created by a stack allocation
>       ==714384==    at 0x10A1B0: ??? (in /src/nfq/src/nfq)
> 
> After searching on this list archive, I found 1 question but without a follow-up answer:
> https://marc.info/?l=netfilter-devel&m=137132916826745&w=4
> 
> Having already spent over a day chasing this. Not having come across other cases on github except this person self reporting[1] made me think it must be indeed something in my code that I'm missing and that could have triggered this. Or is it really rare (harmless) bug in libnetfilter?

I guess this is the typical "problem" situation in which userspace uses
a non-zeroed buffer to feed into sendto() and due to padding not
every byte was written to. So basically userspace "leaks" garbage to
kernel, which is something I'd consider harmless and merely a minor
inconvenience when analyzing with valgrind. I usually suffer from this
as well since libmnl()'s allocation routines don't zero the buffer
either.

In your case, I'd say the error message disappears if you add
'memset(&u, 0, sizeof(u))' to the beginning of nfq_set_mode().

Cheers, Phil
