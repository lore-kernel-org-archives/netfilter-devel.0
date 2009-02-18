From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters
 for a specific rule using iptables/ip6tables
Date: Wed, 18 Feb 2009 21:22:05 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902182118520.12329@fbirervta.pbzchgretzou.qr>
References: <4700595.31361234988274007.JavaMail.root@tahiti.vyatta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Mohit Mehta <mohit.mehta@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35546 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZBRUWH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:22:07 -0500
In-Reply-To: <4700595.31361234988274007.JavaMail.root@tahiti.vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2009-02-18 21:17, Mohit Mehta wrote:

>> Please rediff your patch against the current tree.
>
>diff for iptables.c -

If you have trouble generating patches quickly, I can suggest the
use of the following tools:

 - quilt
   (quilt new mywork.diff; quilt edit iptables.c; quilt ref;
    grab patch from patches/ directory)

 - git
   (git clone; edit files; git add; git commit; git-export-patch)
 - or git with stgit
   (stg new mywork.diff; edit; stg ref; stg export...)



>@@ -2116,6 +2131,8 @@ int do_command(int argc, char *argv[], c
>                if (ret && (command & CMD_ZERO))
>                        ret = zero_entries(chain,
>                                           options&OPT_VERBOSE, handle);
>+               if (ret && (command & CMD_ZERO_NUM))
>+                       ret = iptc_zero_counter(chain, rulenum, handle);
>                break;
>        case CMD_NEW_CHAIN:
>                ret = iptc_create_chain(chain, handle);
>
>
>
>
>
>
>diff for ip6tables.c -
>
>--- ip6tables.c.orig    2009-02-18 11:44:04.000000000 -0800
>+++ ip6tables.c 2009-02-18 11:50:51.000000000 -0800
>@@ -79,9 +79,10 @@
> #define CMD_SET_POLICY         0x0400U
> #define CMD_RENAME_CHAIN       0x0800U
> #define CMD_LIST_RULES         0x1000U
>-#define NUMBER_OF_CMD  14
>+#define CMD_ZERO_NUM           0x2000U
>+#define NUMBER_OF_CMD  15
> static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
>-                                'N', 'X', 'P', 'E', 'S' };
>+                                'Z', 'N', 'X', 'P', 'E', 'S' };
>
> #define OPTION_OFFSET 256
>
