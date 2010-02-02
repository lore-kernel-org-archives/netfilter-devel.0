From: Susant Sahani <ssahani@gmail.com>
Subject: NF_STOLEN and re-insert in to IP stack
Date: Tue, 2 Feb 2010 17:17:03 +0530
Message-ID: <d81115a61002020347n91409dav4bb939a13768b05f@mail.gmail.com>
References: <d81115a61001300058o65e0c079nf4d8469da024b53c@mail.gmail.com>
	<d81115a61001300358s82df29fldd01322ea23a612a@mail.gmail.com>
	<d81115a61001300359q5831092dh35af6c7505a88705@mail.gmail.com>
	<20100202113832.GS17420@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:56266 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab0BBLrX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2010 06:47:23 -0500
Received: by pxi12 with SMTP id 12so5666842pxi.33
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Feb 2010 03:47:23 -0800 (PST)
In-Reply-To: <20100202113832.GS17420@prithivi.gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 =A0Hi,

 =A0I have yet to find any resource that answers this question. =A0If I
 have =A0a kernel module that registers a callback with netfilter and
 steals a =A0packet during the NF_IP_PRE_ROUTING stage, How can I
 re-insert this =A0packet on the network stack, (before the ip routing
 stage) .

 =A0susant
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
