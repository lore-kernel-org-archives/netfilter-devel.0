From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] conntrack match typo
Date: Mon, 23 Aug 2004 20:42:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <412A3A8D.8010800@trash.net>
References: <20040821215419.GA29488@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Oester <phil@linuxace.com>
In-Reply-To: <20040821215419.GA29488@linuxace.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>Status option should use IPT_CONNTRACK_STATUS, not IPT_CONNTRACK_STATE.
>Originally noticed by M. J. Pomraning. 
>
>This fixes bug #194
>  
>
Applied, thanks.

Regards
Patrick

>Phil
> 
>
>diff -ru ipt-orig/extensions/libipt_conntrack.c ipt-new/extensions/libipt_conntrack.c
>--- ipt-orig/extensions/libipt_conntrack.c      2004-06-14 18:02:17.000000000 -0400
>+++ ipt-new/extensions/libipt_conntrack.c       2004-08-21 17:51:05.507406408 -0400
>@@ -492,7 +492,7 @@
> 
>        if(sinfo->flags & IPT_CONNTRACK_STATUS) {
>                printf("%sctstatus ", optpfx);
>-               if (sinfo->invflags & IPT_CONNTRACK_STATE)
>+               if (sinfo->invflags & IPT_CONNTRACK_STATUS)
>                        printf("! ");
>                print_status(sinfo->statusmask);
>        }
>
>  
>
