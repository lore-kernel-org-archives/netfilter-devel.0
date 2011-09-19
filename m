From: Peter Volkov <pva@gentoo.org>
Subject: ipset-6.9.1: 3.0.4 kernel tests failure
Date: Mon, 19 Sep 2011 17:29:37 +0400
Message-ID: <1316438977.7764.6.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48459 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab1ISNa7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:30:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi. I've ran ipset-6.9.1 test suite on 3.0.4 kernel and it failed:

bitmap:ip: Network: Create a set from a valid network with timeout:
passed
bitmap:ip: Network: Add lower boundary: FAILED
Failed test: ../src/ipset 2>.foo.err add test 2.0.0.0 timeout 0
ipset v6.9.1: Element is out of the range of the set

Is this expected? ipset-6.8 has the same problem.

BTW, in general is it better to use in-kernel modules or kernel modules
bundled with ipset? Personally I'd better pushed required patches into
our kernels and suggested users to use them, but where it's better to
pull such patches from?

Thank you in advance.

--
Peter.

