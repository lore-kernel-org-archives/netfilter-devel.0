From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re[2]: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Tue, 24 Mar 2009 06:17:12 +0300
Message-ID: <504490263.20090324061712@yandex.ru>
References: <1691181420.20090323214823@yandex.ru>  <49C7E095.9020002@trash.net>
 <1237845953.4786.47.camel@ice-age>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards5.yandex.ru ([77.88.61.37]:56320 "EHLO
	forwards5.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZCXDQM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 23:16:12 -0400
Received: from smtp19.yandex.ru (smtp19.yandex.ru [77.88.61.35])
	by forwards5.yandex.ru (Yandex) with ESMTP id 40C66AD344
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 06:16:07 +0300 (MSK)
Received: from gw-212.mjknet.ru ([212.45.5.114]:39179 "EHLO www1.firststeps.ru"
        smtp-auth: "kuzinandrey" TLS-CIPHER: <none> TLS-PEER-CN1: <none>)
        by mail.yandex.ru with ESMTP id S3096743AbZCXDP6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2009 06:15:58 +0300
In-Reply-To: <1237845953.4786.47.camel@ice-age>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

EL> I don't think the described mechanism is generic enough to be a default
EL> behaviour. It should be useful for projects like snort-inline but it
EL> will really a problem for software like NuFW which are asynchronous by
EL> design.
EL> In NuFW, packet authentication is triggered by a user message (signing
EL> of packet is done is userspace). Thus the ordering of the answer depends
EL> of the ordering of user messages. As NuFW authenticate packet at network
EL> scale (there is thus plenty of users), it is not possible to assume that
EL> the answer will be ordered.
EL> Thus, even if it could be useful, this mechanism should only be
EL> activated by an explicit userspace query. 

Indeed. I use nfqueue for traffic accounting on network gateway. And
as i describe in previous letters after _several tens of millions_ packets
every time i have one or more such packets without verdict.
I can't find any errors in userspace, and i think that Patrick way
may be don't work for catching problem place, earlier i try to use
nfqnl_test example program (easier can't be imagine) for verdict
sending, and some packets don't get verdicts. May be errors take place
in kernel on high load bandwidths due to some SMP/RCU bugs, skbuf
or hardware drivers bugs (forcedeth for example is not so perfect
driver because write by reverse engineering way).
So this patch for me can automatically erase any delays on gateway
due to trash queue fills. I think this feature need to be realize as
menu config options (for people who really need this).



