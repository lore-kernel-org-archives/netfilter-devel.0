From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] xtables: Add an interval option for xtables lock wait
Date: Thu, 23 Jun 2016 20:44:01 +0200
Message-ID: <20160623184401.GA12620@salvia>
References: <1465957673-1637-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38168 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbcFWSoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 14:44:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5A129EAA7D
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:44:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 490C4100794
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:44:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2BD041150D3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 20:44:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465957673-1637-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Subash,

On Tue, Jun 14, 2016 at 08:27:53PM -0600, Subash Abhinov Kasiviswanatha=
n wrote:
> ip[6]tables currently waits for 1 second for the xtables lock to be
> freed if the -w option is used. We have seen that the lock is held
> much less than that resulting in unnecessary delay when trying to
> acquire the lock. This problem is even severe in case of latency
> sensitive applications.
>=20
> Introduce a new option 'W' to specify the wait interval in decimal
> format [seconds.microseconds]. If this option is not specified,
> the command sleeps for 1 second by default.

Compilation breaks with this patch:

 xtables.c: In function =E2=80=98do_parse=E2=80=99:
 xtables.c:1029:8: error: =E2=80=98restore=E2=80=99 undeclared (first u=
se in this function)
    if (restore) {
        ^
 xtables.c:1029:8: note: each undeclared identifier is reported only on=
ce for each function it appears in
 Makefile:778: recipe for target 'xtables_compat_multi-xtables.o' faile=
d
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
