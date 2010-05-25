From: Brian Schang <netfilter@lists.schang.net>
Subject: Re: [PATCH] utils: add missing include flags to Makefile
Date: Mon, 24 May 2010 21:02:03 -0400
Message-ID: <4BFB218B.3070609@lists.schang.net>
References: <4BF74E78.1030805@lists.schang.net> <1274680413-25691-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1274680413-25691-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan:

On 5/24/2010 1:53 AM, Jan Engelhardt wrote:
> Fixes this compile error:
>
>    CC     nfnl_osf.o
> nfnl_osf.c:48:36: fatal error: linux/netfilter/xt_osf.h: No such file or directory
> compilation terminated.
>
> References: http://marc.info/?l=netfilter&m=127449929621579&w=2
> Signed-off-by: Jan Engelhardt<jengelh@medozas.de>
> ---
>   utils/Makefile.am |    2 ++
>   1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/utils/Makefile.am b/utils/Makefile.am
> index d023b0c..79ce34b 100644
> --- a/utils/Makefile.am
> +++ b/utils/Makefile.am
> @@ -1,5 +1,7 @@
>   # -*- Makefile -*-
>
> +AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
> +
>   sbin_PROGRAMS = nfnl_osf
>   pkgdata_DATA = pf.os

Complied and works great now. Thank you for the help! I appreciate it.

Have a great day.

-- 
Brian
