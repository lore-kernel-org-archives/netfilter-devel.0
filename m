From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] masquerading/conntrack
Date: Wed, 21 May 2008 16:04:51 +0200
Message-ID: <48342C03.10204@netfilter.org>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>	 <4833F119.7080206@netfilter.org> <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080003040201050100020607"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58156 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbYEUOE6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 May 2008 10:04:58 -0400
In-Reply-To: <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080003040201050100020607
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

NICOLAS BOULIANE wrote:
> Hi,
> 
> thank you for your comments.
> ---
> 
> Pablo:
> 
> cc1: warnings being treated as errors
> read_config_lex.l: In function 'yylex':
> read_config_lex.l:113: warning: incompatible implicit declaration of
> built-in function 'strdup'
> read_config_lex.l:114: warning: incompatible implicit declaration of
> built-in function 'strdup'
> read_config_lex.l:115: warning: incompatible implicit declaration of
> built-in function 'strdup'
> read_config_lex.l:126: warning: incompatible implicit declaration of
> built-in function 'strdup'
> read_config_lex.c:3845: warning: label 'find_rule' defined but not used
> make[1]: *** [read_config_lex.o] Error 1
> 
> I get this while compiling the last git snapshot
> probably string.h is missing ?

Does the patch attached fix it?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------080003040201050100020607
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/src/read_config_lex.l b/src/read_config_lex.l
index eb3368a..7daaeab 100644
--- a/src/read_config_lex.l
+++ b/src/read_config_lex.l
@@ -19,6 +19,8 @@
  * Description: configuration file syntax
  */
 
+#include <string.h>
+
 #include "read_config_yy.h"
 %}
 

--------------080003040201050100020607--
