From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] xt_u32.c - make negative offsets work near / at the end
 of packet
Date: Sun, 6 Sep 2009 03:01:19 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909060253510.4335@obet.zrqbmnf.qr>
References: <1252197398-23863-1-git-send-email-soltys@ziu.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51073 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbZIFBBR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Sep 2009 21:01:17 -0400
In-Reply-To: <1252197398-23863-1-git-send-email-soltys@ziu.info>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-09-06 02:36, Michal Soltys wrote:
>But with current xt_u32.c code this is impossible due to subsequent
>sanity checks:
>
>        if (at + val < at)
>                return false;
>        at += val;
>        pos = number;
>        if (at + 4 < at || skb->len < at + 4 (#3) ||
>            pos > skb->len - at - 4 (#4) )
>                return false;
>
>        if (skb_copy_bits(skb, at + pos, &n,
>            sizeof(n)) < 0)
>
>In particular, condition (#3) will make the function return false, if
>'at' is at / near the end of packet, regardless of the 'pos' value used.
>Furthermore, (#4) would inhibit any "negative" 'pos' value anyway.
>
>If I haven't missed anything,

The code stems from Patrick's comments [to my original u32 submission]
about overflow checks. It seems you are basically throwing these
out of the window.

>        at += val;

This can overflow. Or if @val is signed, it may even underflow, and
surely give funny results when @at is unsigned at the same time.
Then there is also the question on what should happen when you
deal with values that are - in their respective context as
defined in an RFC or something - uint32_ts. Though probably a little
unlikely in the real world at this time, I would not count on
never hitting a jumbo frame size field of, say, 2147483656 bytes.

>        if (at + number + 4 < 4 || skb->len < at + number + 4)

at+number can overflow, so can at+number+4.
The check is insufficient too, because let at+number+4 may yield,
through overflows, a value that is still greater than 4.
