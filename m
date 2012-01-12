From: marty <martinbarrowcliff@gmail.com>
Subject: ulogd2 suggest
Date: Thu, 12 Jan 2012 18:05:59 -0500
Message-ID: <4F0F6757.8090700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60670 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab2ALXGD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:06:03 -0500
Received: by qcsg13 with SMTP id g13so1350358qcs.19
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2012 15:06:02 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulogd2 is NOT a prime-time candidate. Never has been.
The API has been broken a long time.
Too many issues unresolved.

The wise way to fix the endian issues I documented are to use
host byte order from the very beginning, as per my freely given patch.
That leaves all math options open.
That patch is absolutely correct. Won't break the core design.

NOW, to provide endian conversion simply write a tiny filter module
that does endian conversion of addresses. Duh! How hard could that be?
Then the user can add that mod to stack as needed for an instance,
but it is not global and he can still enjoy both formats.
Gaa, how simple can it get?

Then of course remove every line in every other module that changes
byte order. That is totally inconsistent behavior and wrong.

Likewise IPV6 is NOT the default protocol yet so any and ALL IPv6
conversions need to be done by a single module the user can add to
the stack only when/where desired.
It is stupid and redundant to hardwire that into every module.
Get that out of the other modules and into a single filter.

The database modules NEED to have more options in the config file,
or a LOT of capabilities are unavailable. This is particular to
each DBMS or DBI, so those need to be addressed individually.

After that we should have a much more logical API to work with.

I dare you to tell me I am wrong.

Marty B.












