From: Karel Rericha <karel@maxtel.cz>
Subject: Re: Extending class handle from 16bit to 32bit
Date: Fri, 1 Mar 2013 10:22:21 +0100
Message-ID: <CAN==1Rrj7aPqSs1CqegnR264JsuNmbSzdt99+_A+N1p45PJD9g@mail.gmail.com>
References: <CAN==1RrDHivRrzE1FKcDykRkgh2Obp+XC+5NEeuOE0NWJ=cn_g@mail.gmail.com>
	<20130228135209.1f82c7b3@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:56812 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739Ab3CAJWX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Mar 2013 04:22:23 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so1243892bkc.24
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Mar 2013 01:22:21 -0800 (PST)
In-Reply-To: <20130228135209.1f82c7b3@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> a) low effort
>> Fork hfsc and in forked hfsc interpret 32bit handle as 8bit qdisc and
>> 24bit class.
>> - not "clean" solution, no chance to accept to mainstream IMHO
>> - requires just fork hfsc and add support for forked hfsc to iptables ???

> The handle is baked into the kernel binary API, You can't change it without
> a doing a whole new netlink API and have compatibility layer.

Stephen, is "low effort" way possible ? Any ideas what difficulties
can we walk into if going that way ?

Karel
