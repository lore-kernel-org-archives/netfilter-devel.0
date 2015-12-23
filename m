From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_MARK: Add translation to nft
Date: Wed, 23 Dec 2015 21:52:36 +0530
Message-ID: <CAKHNQQEKcVZs6bnEvR=cPeuGJNrfL1zUQVO=oa3QdR+pCvKjNQ@mail.gmail.com>
References: <20151223153353.GA17748@gmail.com> <alpine.LSU.2.20.1512231714490.9969@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38517 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbbLWQW5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 11:22:57 -0500
Received: by mail-wm0-f51.google.com with SMTP id l126so156186643wml.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 08:22:57 -0800 (PST)
In-Reply-To: <alpine.LSU.2.20.1512231714490.9969@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 9:45 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Wednesday 2015-12-23 16:33, Shivani Bhardwaj wrote:
>>+++ b/extensions/libxt_MARK.c
>>@@ -242,7 +242,24 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
>> {
>>       const struct xt_mark_tginfo2 *info = (const void *)target->data;
>>
>>-      printf(" --set-xmark 0x%x/0x%x", info->mark, info->mask);
>>+      printf(" --set mark 0x%x/0x%x", info->mark, info->mask);
>>+}
>
> This looks like it will break regular iptables.

This is my mistake. I'm correcting this. Could you please tell about
the options or-, and-, mark? Does nftables have an option
corresponding to these?

Thank you
