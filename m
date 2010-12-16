From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: [netfilter_queue] nfq_get_payload: how to get link level payload?
Date: Thu, 16 Dec 2010 18:35:42 +0200
Message-ID: <AANLkTimu9rk2n7utgy=_KszDM3uMSeABoztnKeA2bNuC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54182 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab0LPQgX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:36:23 -0500
Received: by gyb11 with SMTP id 11so1729015gyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Dec 2010 08:36:22 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
what is a best way to get Ethernet header with payload? (or, is it
possible to painlessly get Ethernet header at queue callback at all?)

cheers,
Igor
