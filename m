From: marty <martinbarrowcliff@gmail.com>
Subject: ulogd2 on valgrind
Date: Wed, 23 Nov 2011 09:57:31 -0500
Message-ID: <4ECD09DB.2060808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40915 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1KWO5e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Nov 2011 09:57:34 -0500
Received: by vbbfc26 with SMTP id fc26so515402vbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2011 06:57:34 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ulogd2 was compiled from current Git using recent x86 toolchain.

# valgrind --leak-check=yes  /usr/sbin/ulogd -d
==22245== Memcheck, a memory error detector
==22245== Copyright (C) 2002-2011, and GNU GPL'd, by Julian Seward et al.
==22245== Using Valgrind-3.8.0.SVN and LibVEX; rerun with -h for 
copyright info
==22245== Command: /usr/sbin/ulogd -d
==22245==
==22245== Invalid read of size 4
==22245==    at 0x804A012: create_stack (ulogd.c:536)
==22245==    by 0x804C83D: config_parse_file (conffile.c:198)
==22245==    by 0x804B4DC: main (ulogd.c:949)
==22245==  Address 0x28 is not stack'd, malloc'd or (recently) free'd
==22245==
==22245==
==22245== Process terminating with default action of signal 11 (SIGSEGV)
==22245==  Access not within mapped region at address 0x28
==22245==    at 0x804A012: create_stack (ulogd.c:536)
==22245==    by 0x804C83D: config_parse_file (conffile.c:198)
==22245==    by 0x804B4DC: main (ulogd.c:949)
==22245==  If you believe this happened as a result of a stack
==22245==  overflow in your program's main thread (unlikely but
==22245==  possible), you can try to increase the size of the
==22245==  main thread stack using the --main-stacksize= flag.
==22245==  The main thread stack size used in this run was 8388608.
==22245==
==22245== HEAP SUMMARY:
==22245==     in use at exit: 15,888 bytes in 107 blocks
==22245==   total heap usage: 129 allocs, 22 frees, 17,866 bytes allocated
==22245==
==22245== LEAK SUMMARY:
==22245==    definitely lost: 0 bytes in 0 blocks
==22245==    indirectly lost: 0 bytes in 0 blocks
==22245==      possibly lost: 0 bytes in 0 blocks
==22245==    still reachable: 15,888 bytes in 107 blocks
==22245==         suppressed: 0 bytes in 0 blocks
==22245== Reachable blocks (those to which a pointer was found) are not 
shown.
==22245== To see them, rerun with: --leak-check=full --show-reachable=yes
==22245==
==22245== For counts of detected and suppressed errors, rerun with: -v
==22245== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 103 from 11)
Segmentation fault

If additional tests are desired please ask.

Marty B.
