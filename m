From: Ian Bishop <ian@pace7.com>
Subject: [BUG] libnftnl examples/nft-rule-parse-add.c hangs
Date: Mon, 17 Nov 2014 10:23:11 +1000
Message-ID: <54693FEF.6010801@pace7.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:43138 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbaKQAXQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Nov 2014 19:23:16 -0500
Received: by mail-pa0-f53.google.com with SMTP id kq14so2151802pab.40
        for <netfilter-devel@vger.kernel.org>; Sun, 16 Nov 2014 16:23:16 -0800 (PST)
Received: from [192.168.1.10] (156.38.96.58.static.exetel.com.au. [58.96.38.156])
        by mx.google.com with ESMTPSA id qc8sm33343763pdb.70.2014.11.16.16.23.14
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 16 Nov 2014 16:23:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As reported on Bugzilla: http://bugzilla.netfilter.org/show_bug.cgi?id=983

The libnftnl example program nft-rule-parse-add.c hangs waiting for 
mnl_socket_recvfrom


Tested using latest libnftnl and libmnl from Git repo, on Fedora 20 x86_64
