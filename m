From: Alex Maltinsky <maltalex@gmail.com>
Subject: Negative value in /proc/net/netfilter/nfnetlink_queue
Date: Sun, 26 May 2013 13:28:07 +0300
Message-ID: <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com>
References: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:43066 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab3EZK2i (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 06:28:38 -0400
Received: by mail-ob0-f181.google.com with SMTP id dn14so6927596obc.40
        for <netfilter-devel@vger.kernel.org>; Sun, 26 May 2013 03:28:38 -0700 (PDT)
In-Reply-To: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I've stumbled across the issue on a heavily loaded system that uses
the nfqueue. After a few days, the number of packets wraps around:

root@xxxx ~ # cat /proc/net/netfilter/nfnetlink_queue
    1   2401  1024 2  4096 247495836     0 -894731272  1

The negative value messes up the application layer statistics.

Is this a new issue or has it been fixed in recent versions?

I couldn't find anything in the changelog so I've decided not to
update libnfnetlink since it's an otherwise stable production machine
running a three year old version (0.0.39).
Second, is there a way of getting the correct value besides keeping
track of the number of wraparounds and compensating for them?


Thanks!
