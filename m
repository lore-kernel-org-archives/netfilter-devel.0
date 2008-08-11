From: Pavol Rusnak <prusnak@suse.cz>
Subject: NAT - randomize the port selection
Date: Mon, 11 Aug 2008 16:15:24 +0200
Message-ID: <48A0497C.9060607@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57337 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751564AbYHKOLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2008 10:11:11 -0400
Received: from [10.20.1.132] (leira.suse.cz [10.20.1.132])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: prusnak)
	by mail.suse.cz (Postfix) with ESMTP id 8A6276280E2
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2008 16:11:23 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello!

Recently there was an issue identified on DNS module about the need to 
randomize the port selection.  I'd like to know if this is already taken 
care in NAT modules in iptables? Could you please let me know if port 
selection is already randomized in these modules ?

-- 
Best Regards / S pozdravom,

Pavol RUSNAK                                       SUSE LINUX, s.r.o
Package Maintainer                                Lihovarska 1060/12
PGP 0xA6917144                                     19000 Praha 9, CR
prusnak[at]suse.cz                                http://www.suse.cz
