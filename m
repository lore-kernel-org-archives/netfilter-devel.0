From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: ebtables not working correctly with 1086bbe97a074844188c6c988fa0b1a98c3ccbb9
Date: Tue, 26 May 2015 04:09:41 +0200
Message-ID: <5563D5E5.70502@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davej@codemonkey.org.uk, Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.134]:57401 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbbEZCSL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 22:18:11 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 965B2FBA13B
	for <netfilter-devel@vger.kernel.org>; Tue, 26 May 2015 04:09:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

setting rules with ebtables does not work for me any more with
1086bbe97a074844188c6c988fa0b1a98c3ccbb9 / "netfilter: ensure number of
counters is >0 in do_replace()" in place.

There is an error message and no rules set in the end.

e.g.

root@kali:~# ebtables -t nat -A POSTROUTING --src 12:34:56:78:9a:bc -j DROP
Unable to update the kernel. Two possible causes:
1. Multiple ebtables programs were executing simultaneously. The ebtables
   userspace tool doesn't by default support multiple ebtables programs
running
   concurrently. The ebtables option --concurrent or a tool like flock
can be
   used to support concurrent scripts that update the ebtables kernel
tables.
2. The kernel doesn't support a certain ebtables extension, consider
   recompiling your kernel or insmod the extension.
.

The rule is not set:

root@kali:~# ebtables -t nat -Ln --Lc
Bridge table: nat

Bridge chain: PREROUTING, entries: 0, policy: ACCEPT

Bridge chain: OUTPUT, entries: 0, policy: ACCEPT

Bridge chain: POSTROUTING, entries: 0, policy: ACCEPT

With 1086bbe97a074844188c6c988fa0b1a98c3ccbb9 reverted everything works
fine again.

root@kali:~# ebtables -t nat -A POSTROUTING --src 12:34:56:78:9a:bc -j DROP
root@kali:~# ebtables -t nat -Ln --Lc
Bridge table: nat

Bridge chain: PREROUTING, entries: 0, policy: ACCEPT

Bridge chain: OUTPUT, entries: 0, policy: ACCEPT

Bridge chain: POSTROUTING, entries: 1, policy: ACCEPT
-s 12:34:56:78:9a:bc -j DROP , pcnt = 0 -- bcnt = 0

It is not this particular example, almost every rule I want to add with
ebtables leads to this error message.

Any ideas why this is happening? I used Debian 7 packaged ebtables
version and newly compiled ebtables from current git repository, same
result for both.

Regards,
Bernhard
