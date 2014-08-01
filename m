From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: what is the default value of /proc/sys/net/netfilter/nf_conntrack_helper
 ?
Date: Fri, 01 Aug 2014 20:12:21 +0200
Message-ID: <53DBD885.4060707@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:55295 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670AbaHASMY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:12:24 -0400
Received: from [192.168.178.21] ([78.54.139.125]) by mail.gmx.com (mrgmx101)
 with ESMTPSA (Nemesis) id 0MRTiG-1X2Eik1fia-00Sfnl for
 <netfilter-devel@vger.kernel.org>; Fri, 01 Aug 2014 20:12:22 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


The doc in states :

nf_conntrack_helper - BOOLEAN
        0 - disabled
        not 0 - enabled (default)

        Enable automatic conntrack helper assignment.


but is that still true ?


-- 
Toralf

