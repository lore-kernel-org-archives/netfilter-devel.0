From: marty <martinbarrowcliff@gmail.com>
Subject: Ulogd - mysql addresses are in network-byte order
Date: Sat, 31 Dec 2011 11:36:36 -0500
Message-ID: <4EFF3A14.10705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qw0-f53.google.com ([209.85.216.53]:65415 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1LaQgj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Dec 2011 11:36:39 -0500
Received: by qadb15 with SMTP id b15so9749483qad.19
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Dec 2011 08:36:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is NOT a bug,  but I believe it needs consideration for change.
So lets call it a feature request to stay friendly.

ulogd.c:733 assigning `ip.saddr(?)' as source for MYSQL(ip.saddr)
ulogd.c:733 assigning `ip.daddr(?)' as source for MYSQL(ip.daddr)

On a little-endian architecture these values are incompatable with
the native math functions and totally unsuitable for making
comparisons in mysql.

eg:
if (( ip.saddr > nnnnnnnnn ) AND ( ip.saddr < mmmmmmmm)) ...
This simply will not work on a little endian machine.

It is impractical to do a byte order conversion using a bunch
of the high level routines within mysql, and it may not be
timely to do it later using a scripting language.

IMHO I believe it is appropriate for these values to be in
host-byte order before they are ever assigned to mysql.
This would then match the byte order of any machine.
If there are compelling reasons to use network byte order,
I suggest this be a configurable option, not the default.

Thanks for a great piece of software,

Marty B.

