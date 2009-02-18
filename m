From: Mohit Mehta <mohit.mehta@vyatta.com>
Subject: Re: [PATCH] iptables: expose option to zero packet and byte
 counters for a specific rule using iptables/ip6tables
Date: Wed, 18 Feb 2009 12:32:01 -0800 (PST)
Message-ID: <9174114.31441234989121915.JavaMail.root@tahiti.vyatta.com>
References: <alpine.LSU.2.00.0902182118520.12329@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:45051 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbZBRUb7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:31:59 -0500
In-Reply-To: <alpine.LSU.2.00.0902182118520.12329@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>If you have trouble generating patches quickly, I can suggest the
>use of the following tools:

> - quilt
>   (quilt new mywork.diff; quilt edit iptables.c; quilt ref;
>    grab patch from patches/ directory)

> - git
>   (git clone; edit files; git add; git commit; git-export-patch)
> - or git with stgit
>   (stg new mywork.diff; edit; stg ref; stg export...)


Thanks for these suggestions. 

It should be noted that I did these changes to the latest source that I grabbed
from debian sid. May be I should have just git cloned it from iptables repository. 
let me knw if these aren't any good and I'll patch em against the most current version of iptables.


----- Original Message -----
From: "Jan Engelhardt" <jengelh@medozas.de>
To: "Mohit Mehta" <mohit.mehta@vyatta.com>
Cc: "Patrick McHardy" <kaber@trash.net>, netfilter-devel@vger.kernel.org
Sent: Wednesday, February 18, 2009 12:22:05 PM (GMT-0800) Auto-Detected
Subject: Re: [PATCH] iptables: expose option to zero packet and byte counters for a specific rule using iptables/ip6tables


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
