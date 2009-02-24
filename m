From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] conntrack-tools 0.9.11 released
Date: Tue, 24 Feb 2009 10:59:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902241035050.30346@fbirervta.pbzchgretzou.qr>
References: <49A03C73.8010004@netfilter.org> <20090222233433.0dc8f396@liberty.rlwhome.lan> <alpine.LSU.2.00.0902230815570.20446@fbirervta.pbzchgretzou.qr> <49A26A3E.5020707@netfilter.org> <20090223093416.2c63fc02@liberty.rlwhome.lan>
 <alpine.LSU.2.00.0902231753190.12150@fbirervta.pbzchgretzou.qr> <20090223210242.0c385736@liberty.rlwhome.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org
To: Robby Workman <rw@rlworkman.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20090223210242.0c385736@liberty.rlwhome.lan>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tuesday 2009-02-24 04:02, Robby Workman wrote:
>Not happening that way here (and bits.h indeed does not include
>limits.h) - see attached plaintext...

Mystery solved.

[glibc.rpm changelog]
* Thu Apr 10 2008 pbaudis@suse.cz
- Temporarily revert a namespace leakage cleanup in glibc-2.8 since
  it causes a lot of build failures

--- sysdeps/unix/sysv/linux/bits/socket.h   
+++ sysdeps/unix/sysv/linux/bits/socket.h
@@ -26,8 +26,10 @@
 #endif   
 
 #define        __need_size_t  
+#define __need_NULL
 #include <stddef.h>
 
+#include <limits.h>
 #include <sys/types.h>
 
 /* Type for length arguments in socket calls.  */
