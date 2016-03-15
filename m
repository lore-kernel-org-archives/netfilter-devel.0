From: Piyush Pangtey <gokuvsvegita@gmail.com>
Subject: Memory-leak in nft
Date: Tue, 15 Mar 2016 23:53:05 +0530
Message-ID: <20160315182305.GA4044@fate>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34738 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965543AbcCOSXH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 14:23:07 -0400
Received: by mail-pf0-f179.google.com with SMTP id x3so38879223pfb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 11:23:05 -0700 (PDT)
Received: from fate ([117.219.42.195])
        by smtp.gmail.com with ESMTPSA id q26sm41241957pfi.57.2016.03.15.11.23.01
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 15 Mar 2016 11:23:04 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There is still some memory-leak in nft which is due to no matching free for
xstrdup in scanner.l:580.
In main.c, argv is passed as a const, and in main.c:270 filename points to this
const location (by optarg).
So it would be safe to remove xstrdup from scanner.l:580.

$ sudo valgrind --leak-check=full nft -f ~/backup.nft

==4075== 22 bytes in 1 blocks are definitely lost in loss record 1 of 3
==4075==    at 0x4C2AB80: malloc (in
/usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==4075==    by 0x57A3839: strdup (strdup.c:42)
==4075==    by 0x41C0BD: xstrdup (utils.c:64)
==4075==    by 0x41EFA1: scanner_push_file (scanner.l:581)
==4075==    by 0x426C88: scanner_read_file (scanner.l:601)
==4075==    by 0x406225: main (main.c:347)
==4075== 
==4075== LEAK SUMMARY:
==4075==    definitely lost: 22 bytes in 1 blocks
==4075==    indirectly lost: 0 bytes in 0 blocks
==4075==      possibly lost: 0 bytes in 0 blocks
==4075==    still reachable: 832 bytes in 2 blocks
==4075==         suppressed: 0 bytes in 0 blocks

-- 

With regards,
Piyush Pangtey <gokuvsvegita@gmail.com>
