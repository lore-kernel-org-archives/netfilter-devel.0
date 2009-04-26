From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Wrong MAC in redirected packet
Date: Sun, 26 Apr 2009 18:22:08 +0200
Message-ID: <17e3a8f80904260922v6525aac3hbcb2398ce514446d@mail.gmail.com>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>
	 <49CA8A6B.1020603@gmail.com>
	 <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>
	 <49CA8C5A.1030908@gmail.com>
	 <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
	 <49CA9B8B.7080605@gmail.com>
	 <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com>
	 <alpine.LSU.2.00.0903262106140.15111@fbirervta.pbzchgretzou.qr>
	 <49CBEB9E.7080902@gmail.com>
	 <alpine.LSU.2.00.0904261143001.28183@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:56482 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962AbZDZQWK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 12:22:10 -0400
Received: by bwz7 with SMTP id 7so1872758bwz.37
        for <netfilter-devel@vger.kernel.org>; Sun, 26 Apr 2009 09:22:09 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0904261143001.28183@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>> Turned out that it was the checksums. They were calculated correctly,
>>>> but since I processed packets on input, tcp_hdr and udp_hdr of course
>>>> returned invalid pointers. My code is now more or less RAWNAT, so if
>>>> it is of interest to anybody else I will merge them and make it
>>>> available.
>>>
>>> I have now rebased the RAWNAT branch to Xt-a's master and
>>> made the rawpost tables workable with all kernel versions.
>>> It does not have MAC addr punning yet.
>
> I am just rethinking this. There are cases where we do not want MAC punning.
> (E.g. when a packet still needs to be routed through another gateway
> instead of being delivered directly to the final ethernet segment.)
>
> Is --to-mac aa:bb:cc:dd:ee:ff sufficient, or did you want --to-mac IPaddr?

The last one would be the easiest to use and would therefore be
desirable. However, forcing the user to write the full MAC-address
might limit scenarios where it is used wrongly.

-Kristian
