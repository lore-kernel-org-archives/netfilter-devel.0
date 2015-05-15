From: Felix Janda <felix.janda@posteo.de>
Subject: libnetfilter_*: Use uint*_t instead of u_int*_t
Date: Fri, 15 May 2015 21:10:39 +0200
Message-ID: <20150515191039.GB16749@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:58807 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbbEOTKz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 May 2015 15:10:55 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id E295325AF537
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 21:10:53 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpK8F4LgWz5vN2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 May 2015 21:10:53 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I've been trying to build many netfilter.org projects on a system with
the musl libc library. Alas, I often get errors about undeclared
u_int8_t, ... musl will declare these types when <sys/types.h> is
included and _GNU_SOURCE or _BSD_SOURCE is set. However many
netfilter.org projects don't include <sys/types.h>.

On the other hand, changing the types to the <stdint.h> uint*_t works
in most cases because <netinet/in.h> is often included, which (by POSIX)
includes <inttypes.h> which includes <stdint.h>. (Sometimes <stdint.h> or
<inttypes.h> is also directly included.)

In some cases u_int*_t and uint*_t types are mixed, so I am going to
prepare a patch series which changing them and making sure that the
public headers explicitly include <stdint.h> if they use these types.

Assuming these (relatively invasive in terms of changed lines of code)
changes are acceptable, I have some questions:

Are the linux_nfnetlink_*.h only used as includes from other headers?
(so that they don't need an explicit #include <stdint.h>)

Is there anything I need to be careful about?


There are also kernel types (e.g. __u8) in some places. Should I also
bother about these while I'm at it? These were not problematic for me
since these (mostly?) kernel headers include <linux/types.h>.

Thanks,
Felix
