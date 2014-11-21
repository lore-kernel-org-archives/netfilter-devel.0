From: Feng Gao <gfree.wind@gmail.com>
Subject: netfilter: xt_connlimit: it could get the accurate conn count with
 heavy traffic and multi cores
Date: Fri, 21 Nov 2014 19:30:39 +0800
Message-ID: <CA+6hz4pLYjvhxki5OrJAeUuf6UNhHv20GoFA2QqpOj-uZ-buXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:34730 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758225AbaKULak (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Nov 2014 06:30:40 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so4724328iec.11
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Nov 2014 03:30:39 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I find the xt_connlimit could not get the accurate conn count with
heavy traffic on multiple cores platform.

For example, I create one rule as following:
iptables -t raw -A PREROUTING -s 192.168.3.88 -m connlimit
--connlimit-above 100 --connlimit-mask 32 -j DROP

I use the Thunder (one P2P download tool) to test.
As a result, the total conn count of 192.168.3.88 could reach the 300+.

Then I make some steps to fix it and the conn count only reach the 100
~ 120 at most.

I planed to commit one patch, but I think the already-closed conn is
not counted by current  xt_connlimit. (Even though the already-closed
conn is counted, the current xt_connlimit still could not  get the
accurate count. There are other changes to enhance it.).

So is it necessary to get the very accurate count for xt_connlimit?
If so, why don't count the already-closed conn?
If not, my patch is necessary.


Best Regards
Feng
