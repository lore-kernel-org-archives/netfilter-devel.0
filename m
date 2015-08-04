From: Andreas Schultz <aschultz@tpip.net>
Subject: nfacct is not namespace aware
Date: Tue, 4 Aug 2015 17:56:32 +0200 (CEST)
Message-ID: <1612781863.2309722.1438703792113.JavaMail.zimbra@tpip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([92.43.49.48]:48040 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbHDQFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 12:05:25 -0400
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.tpip.net (Postfix) with ESMTPS id 237C24F414
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2015 15:56:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id EA169A2F03
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2015 17:56:32 +0200 (CEST)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id fVVz3RwDv266 for <netfilter-devel@vger.kernel.org>;
	Tue,  4 Aug 2015 17:56:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by office.tpip.net (Postfix) with ESMTP id 40CF1A2F04
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2015 17:56:32 +0200 (CEST)
Received: from office.tpip.net ([127.0.0.1])
	by localhost (office.tpip.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 4OG4t7L_EJRY for <netfilter-devel@vger.kernel.org>;
	Tue,  4 Aug 2015 17:56:32 +0200 (CEST)
Received: from office.tpip.net (office.tpip.net [92.43.51.2])
	by office.tpip.net (Postfix) with ESMTP id 25E35A2F03
	for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2015 17:56:32 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Can someone confirm that the nfacct subsystem is not network namespace
aware/safe?

>From checking the code, it would appear that all nfacct targets are kept
in a global list. This would mean that unrelated namespaces can interfere
with each other.

Andreas
