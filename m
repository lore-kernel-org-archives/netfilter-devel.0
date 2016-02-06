From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC] a software based on ulogd
Date: Sat, 6 Feb 2016 19:42:49 +0900
Message-ID: <20160206104249.GA19349@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36309 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbcBFKmy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Feb 2016 05:42:54 -0500
Received: by mail-pf0-f174.google.com with SMTP id n128so82358501pfn.3
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Feb 2016 02:42:53 -0800 (PST)
Received: from gmail.com (KD106159154146.ppp-bb.dion.ne.jp. [106.159.154.146])
        by smtp.gmail.com with ESMTPSA id x10sm30314145pas.37.2016.02.06.02.42.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 06 Feb 2016 02:42:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,

I need Netflow data based on conntrack, I am trying to create a software
which is based on ulogd.

    https://github.com/chamaken/nurs/

I copied COPYING and README from ulogd source code to distribute, and
added comment:

    based on ulogd which was almost entirely written by Harald Welte,
    with contributions from fellow hackers such as Pablo Neira Ayuso,
    Eric Leblond and Pierre Chifflier.

to each source file. Would you tell me other things to reuse ulogd?
And I would appreciate it if I could get your advice to this software.

Thanks,
