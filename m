From: Patrick McHardy <kaber@trash.net>
Subject: libnl: fix missing limits.h include
Date: Fri, 20 Mar 2009 18:02:52 +0100
Message-ID: <49C3CC3C.9010906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010906090706010206060203"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33426 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbZCTRC4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:02:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010906090706010206060203
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------010906090706010206060203
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

commit d70b8153a31618fd49af97850dcc7bf329fbe0f5
Author: Patrick McHardy <kaber@trash.net>
Date:   Fri Mar 20 01:46:24 2009 +0100

    libnl: fix missing limits.h include
    
    utils.c: In function 'parse_u32':
    utils.c:23: error: 'ULONG_MAX' undeclared (first use in this function)
    utils.c:23: error: (Each undeclared identifier is reported only once
    utils.c:23: error: for each function it appears in.)
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/src/utils.h b/src/utils.h
index a5c94e6..8c4e884 100644
--- a/src/utils.h
+++ b/src/utils.h
@@ -16,6 +16,7 @@
 #include <string.h>
 #include <stdlib.h>
 #include <inttypes.h>
+#include <limits.h>
 #include <errno.h>
 #include <stdint.h>
 #include <ctype.h>

--------------010906090706010206060203--
