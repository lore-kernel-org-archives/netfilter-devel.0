From: "Matthew L. Creech" <mlcreech@gmail.com>
Subject: Build breakage in 1.4.3
Date: Tue, 21 Apr 2009 16:50:41 -0400
Message-ID: <5ee96a840904211350ofc00f91r98491da19638edf0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:16734 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbZDUUun (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:50:43 -0400
Received: by yw-out-2324.google.com with SMTP id 5so1772092ywb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2009 13:50:41 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When trying to cross-compile iptables 1.4.3 or later, I get:

make[5]: *** No rule to make target `extensions/libext4.a', needed by
`iptables'.  Stop.

The problem seems to be due to this change:

https://git.netfilter.org/cgi-bin/gitweb.cgi?p=iptables.git;a=commit;h=f92d6b05abd217c3e152caa2c494a138ccd5096e

If I revert that, the build completes, but (just guessing from the
commit msg) that doesn't seem like an appropriate general solution.

-- 
Matthew L. Creech
