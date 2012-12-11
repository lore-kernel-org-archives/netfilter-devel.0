From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: Re: how to monitor changes in kernel tables
Date: Tue, 11 Dec 2012 17:52:19 +0100
Message-ID: <50C764C3.5060204@6wind.com>
References: <1355137694.470612479@f293.mail.ru>
Reply-To: nicolas.dichtel@6wind.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: aalexh@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:49479 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab2LKQwX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2012 11:52:23 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so2334574eek.19
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Dec 2012 08:52:22 -0800 (PST)
In-Reply-To: <1355137694.470612479@f293.mail.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 10/12/2012 12:08, aalexh@mail.ru a =C3=A9crit :
> Hi everyone,
> I wonder are there any ready to use and correct from netfilter design=
 point of view API to monitor changes in kernel tables?
There is no mechanism to monitor netfilter tables.

Here is a proposal to do that: http://patchwork.ozlabs.org/patch/186468=
/
but the patch has been rejected for now because netfilter system will b=
e=20
reworked soon.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
