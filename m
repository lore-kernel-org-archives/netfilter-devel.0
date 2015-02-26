From: Pedro Alvarez <pedro.alvarez@codethink.co.uk>
Subject: [PATCH] ebtables: Cache a copy of the v3.16 kernel headers in the
 ebtables tree
Date: Thu, 26 Feb 2015 16:37:56 +0000
Message-ID: <54EF4BE4.4020002@codethink.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:39535 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbbBZQiB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 11:38:01 -0500
Received: from localhost (localhost [127.0.0.1])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTP id 4128746090E
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2015 16:38:00 +0000 (GMT)
Received: from ducie-dc1.codethink.co.uk ([127.0.0.1])
	by localhost (ducie-dc1.codethink.co.uk [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZhnmDTO-kNlO for <netfilter-devel@vger.kernel.org>;
	Thu, 26 Feb 2015 16:37:57 +0000 (GMT)
Received: from [10.24.2.121] (unknown [10.24.2.121])
	by ducie-dc1.codethink.co.uk (Postfix) with ESMTPSA id B03D8460928
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Feb 2015 16:37:56 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone.

I've had some problems trying to build ebtables with the v3.19 kernels headers,
failing to build with the following error:

gcc -Wall -Wunused -Werror -fPIC -O3 -DPROGVERSION=\"2.0.10-4\"
-DPROGNAME=\"ebtables\" -DPROGDATE=\"December\ 2011\"
-D_PATH_ETHERTYPES=\"/etc/ethertypes\" -DEBTD_ARGC_MAX=50
-DEBTD_CMDLINE_MAXLN=2048 -DLOCKFILE=\"/var/lib/ebtables/lock\"
-DLOCKDIR=\"/var/lib/ebtables/\" -c -o extensions/ebt_ulog.o
extensions/ebt_ulog.c -Iinclude/
extensions/ebt_ulog.c:17:45: fatal error: linux/netfilter_bridge/ebt_ulog.h: No
such file or directory
 #include <linux/netfilter_bridge/ebt_ulog.h>
                                             ^

After some discussion on IRC we agreed there were 2 possible solutions:

 -1: Disable 'ulog' in the extensions/Makefile

 -2: Cache the headers needed in the ebtables tree.

I decided to go for 2, and here is the patch:

  Repo: git://git.baserock.org/delta/ebtables.git
  Branch: baserock/pedroalvarez/ebt_ulog-fix
  Sha1: 13747a56890cc710b2b4d420edc03a6c2714f40e

NOTE: I didn't want to send a diff, since it would be big and nonsense, but I
can do that if needed.

Regards!

-- 
Pedro
