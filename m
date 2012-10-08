From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: resolve automake-1.12 warnings
Date: Mon, 8 Oct 2012 17:33:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1210081733080.13488@nerf07.vanv.qr>
References: <1349702239-25213-1-git-send-email-jengelh@inai.de> <1349702239-25213-2-git-send-email-jengelh@inai.de> <20121008151733.GB1647@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49717 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2JHPds (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:33:48 -0400
In-Reply-To: <20121008151733.GB1647@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-10-08 17:17, Pablo Neira Ayuso wrote:

>On Mon, Oct 08, 2012 at 03:17:19PM +0200, Jan Engelhardt wrote:
>> am/ltlibrary.am: warning: 'libnetfilter_queue.la': linking libtool
>> libraries using a non-POSIX archiver requires 'AM_PROG_AR' in
>> 'configure.ac'
>> 
>> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>> ---
>>  bl           |    2 ++
>>  configure.ac |    1 +
>>  2 files changed, 3 insertions(+)
>>  create mode 100644 bl
>> 
>> diff --git a/bl b/bl
>> new file mode 100644
>> index 0000000..57eb8dd
>> --- /dev/null
>> +++ b/bl
>> @@ -0,0 +1,2 @@
>> +Error: '/home/jengelh/code/libnetfilter_queue' is not an osc project dir or working copy
>> +Current directory looks like git.
>
>This slipped through accidentally, please fix it and will pull.

Done and pushed (into my git).


commit 956a8407175cb72ac18513a43f63331af8b3b744
Author: Jan Engelhardt <jengelh@inai.de>
Date:   Mon Oct 8 15:16:32 2012 +0200

    build: resolve automake-1.12 warnings
    
    am/ltlibrary.am: warning: 'libnetfilter_queue.la': linking libtool
    libraries using a non-POSIX archiver requires 'AM_PROG_AR' in
    'configure.ac'
    
    Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac |    1 +
 1 file changed, 1 insertion(+)

diff --git a/configure.ac b/configure.ac
index 0a1fbd6..07747a6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -8,6 +8,7 @@ AC_CONFIG_HEADERS([config.h])
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
        tar-pax no-dist-gzip dist-bzip2 1.6])
+m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
 
 dnl kernel style compile messages
 m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
