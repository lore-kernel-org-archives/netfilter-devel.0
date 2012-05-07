From: Kelvie Wong <kelvie@ieee.org>
Subject: Re: [PATCH] netfilter: nf_ct_expect: partially implement ctnetlink_change_expect
Date: Sun, 6 May 2012 18:53:24 -0700
Message-ID: <CAK2bC5rGv32s9gn7F2rwQJVmJwfv5S2jKLO_TQWc8D6j7FfjtA@mail.gmail.com>
References: <1336005564-23171-1-git-send-email-kelvie@ieee.org>
	<1336005564-23171-3-git-send-email-kelvie@ieee.org>
	<20120506230915.GA23306@1984>
	<CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38728 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab2EGBx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 May 2012 21:53:28 -0400
Received: by bkcji2 with SMTP id ji2so3304203bkc.19
        for <netfilter-devel@vger.kernel.org>; Sun, 06 May 2012 18:53:24 -0700 (PDT)
In-Reply-To: <CAK2bC5rMTMMdepCUpv6oB17ez-LMp=ZUSXacomZXTiM1ZDB92w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 6, 2012 at 6:51 PM, Kelvie Wong <kelvie@ieee.org> wrote:
> ctnetlink_change_expect is not exported, and it is only called in
> ctnetlink_new_expect, which is protected by the spinlock.
>

Also, in a similar function, ctnetlink_change_conntrack, the locking is
done by the caller, in a similar fashion.

-- 
Kelvie Wong
