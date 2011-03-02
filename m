From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: nfqueue: nfq_set_verdict(...., len), where len > MTU?
Date: Wed, 2 Mar 2011 05:11:38 +0200
Message-ID: <AANLkTi=n0N8k8OjQCVA0VTbgOa75bYTobzTufox545bp@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab1CBDMT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Mar 2011 22:12:19 -0500
Received: by wwb22 with SMTP id 22so5315275wwb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 01 Mar 2011 19:12:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all.
I am trying to modify & send out a packet larger than MTU, using
nfq_set_verdict(...., new_payload, len).
len = 200, unsigned char[2000] new_payload is stripped of any null
bytes after TCP header, IP total len (network short) set to 5000.

However, the receiving host keeps getting only 548 bytes, as logged by tcpdump.

So, does NFQUEUE has nothing to do with IP fragmentation even when
listening at mangle table's PREROUTING?
Will be there any positive effect, if I change IP options to DF (dont fragment)?

--
cheers,
Igor
