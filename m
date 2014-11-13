From: Ronny Janssen <ronny.janssen@gmail.com>
Subject: x_tables: eb_tables: limit.0 match: invalid size 32 (kernel) !=
 (user) 24
Date: Thu, 13 Nov 2014 15:25:55 +0100
Message-ID: <CAJsRc6i_vEWAOEUJVrx5t0DtNHZdMg5jj3N726YSOs7zX_pCcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:48673 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932910AbaKMOZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:25:57 -0500
Received: by mail-la0-f41.google.com with SMTP id gf13so1376477lab.14
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2014 06:25:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've come across an issue trying to install an ebtables rules in a
64bit mips kernel from 32bit userland ebtables.

Linux kernel version 3.10.20 mips64 and ebtables mips32 version
v2.0.10-4 (December 2011).

when issuing following command:

/ # ebtables -A FORWARD -i eth0 --limit 10/s -j ACCEPT

the kernel complains with:

[  320.376828] x_tables: eb_tables: limit.0 match: invalid size 32
(kernel) != (user) 24

My lame throw at this is to remove the xt_check_match from
ebt_check_match and for me that works just fine, but I understand this
is not the proper solution.
Question is.. what would be the proper solution? In other words.. what
exaclty is the bug here? Any insight is highly appreciated.

Thanks,
Ronny.
