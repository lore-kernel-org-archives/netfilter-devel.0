From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 03/04: headers_check fix: linux/netfilter/xt_osf.h
Date: Mon, 29 Jun 2009 16:20:17 +0200 (MEST)
Message-ID: <20090629142011.5728.37775.sendpatchset@x2.localnet>
References: <20090629142007.5728.63458.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20090629142007.5728.63458.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 8a3af79361e85db6fec4173ef1916322471c19e3
Author: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date:   Mon Jun 29 14:28:27 2009 +0200

    netfilter: headers_check fix: linux/netfilter/xt_osf.h
    
    fix the following 'make headers_check' warnings:
    
      usr/include/linux/netfilter/xt_osf.h:40: found __[us]{8,16,32,64} type without #include <linux/types.h>
    
    Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/xt_osf.h b/include/linux/netfilter/xt_osf.h
index fd2272e..18afa49 100644
--- a/include/linux/netfilter/xt_osf.h
+++ b/include/linux/netfilter/xt_osf.h
@@ -20,6 +20,8 @@
 #ifndef _XT_OSF_H
 #define _XT_OSF_H
 
+#include <linux/types.h>
+
 #define MAXGENRELEN		32
 
 #define XT_OSF_GENRE		(1<<0)
