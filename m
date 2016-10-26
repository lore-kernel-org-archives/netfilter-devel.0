From: James Feeney <james@nurealm.net>
Subject: Re: reject statement - "crazy" parse error?
Date: Wed, 26 Oct 2016 12:50:23 -0600
Message-ID: <5a8da546-8694-40b8-b514-1f80bff71a44@nurealm.net>
References: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
 <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
Reply-To: james@nurealm.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from resqmta-po-09v.sys.comcast.net ([96.114.154.168]:56251 "EHLO
        resqmta-po-09v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751129AbcJZSuZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 14:50:25 -0400
In-Reply-To: <CAOkSjBjd6CwTcMv_G1p1KmWnQukHUn6f4oCoaeZHmXEyJDiW4g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I can't reproduce the issue here.

Thanks Arturo.  What distribution are you using?  Hmm - any suggestions about
how to "poke" at this issue on my end?

BTW, I can load this file without problem when replacing "reject" with "drop".
Whatever the problem, it is "triggered" by the "reject" statement.

I was concerned that perhaps my system was in some inconsistent upgrade state,
because I noticed I was actually still running kernel 4.8.1-1, not 4.8.4-1.

I tried a reboot and recompiled
nftables-git 0.6.r96.gbb636b8-1
libnftnl-git 1.0.6.r68.gc26951e-1

And now, I get this:

/etc/test.nft:4:1-2: Error: Could not process rule: Operation not supported
table ip private {
^^

Well, that's not good, because something changed, from "No such file or
directory" to "Operation not supported", but it is still not right.  Of course,
in both cases, the error messages are "useless", not saying *what* file, and not
saying *what* operation.

I also tried re-installing the stock
libnftnl   1.0.6-1
nftables  1:0.6-2

Those give the same error message.

Should the linux kernel have any effect on this error?

I noticed there is some debugging support in nft.  The error message is
displayed last with debug scanner or parser, and displayed first with debug
eval.  With debug mnl, the error is displayed in the midst of the output.

Hmm - any thoughts?
