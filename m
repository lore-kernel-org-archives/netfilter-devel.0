From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: Re[2]: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Tue, 24 Mar 2009 08:23:42 +0300
Message-ID: <428440064.20090324082342@yandex.ru>
References: <1691181420.20090323214823@yandex.ru>  <49C7E095.9020002@trash.net>
 <1237845953.4786.47.camel@ice-age> <49C809ED.8070308@trash.net>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards3.yandex.ru ([213.180.223.174]:37597 "EHLO
	forwards3.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZCXFWk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2009 01:22:40 -0400
Received: from smtp10.yandex.ru (smtp10.yandex.ru [213.180.223.92])
	by forwards3.yandex.ru (Yandex) with ESMTP id B5B7A4C51D7
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Mar 2009 08:22:37 +0300 (MSK)
Received: from gw-212.mjknet.ru ([212.45.5.114]:57872 "EHLO www1.firststeps.ru"
        smtp-auth: "kuzinandrey" TLS-CIPHER: <none> TLS-PEER-CN1: <none>)
        by mail.yandex.ru with ESMTP id S5882042AbZCXFW3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Mar 2009 08:22:29 +0300
In-Reply-To: <49C809ED.8070308@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> Thus, even if it could be useful, this mechanism should only be
>> activated by an explicit userspace query. 

PM> Good point. The in-sequence handling is also only necessary per flow,
PM> so this definitely would need to be enabled explicitly.

I fully agree with you, but do this changes it not so easy for me as for you.
I'am newbie in kernel programming. And i think would be better if this
changes will be made by library/kernel maintainer with his experience, point
of view, programming style and other cool stuff.

