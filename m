From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fix for u32 match, problems when parsing arguments
Date: Thu, 02 Sep 2004 22:55:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <413788BF.1080807@trash.net>
References: <20040902122802.GA6427@barbara.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?Piotr_Gasid=B3o?=
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
In-Reply-To: <20040902122802.GA6427@barbara.eu.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Piotr Gasid³o wrote:

>Hello,
>
>I've found bug in u32 iptables helper library.
>
># iptables -A FORWARD -m u32 --u32 "0&0xffffffff=0"
>iptables v1.2.11: u32: at char 2 error reading number
>  
>
>Attached patch, fixes problem.
>  
>
Applied, thanks.

Regards
Patrick

>  
>
>------------------------------------------------------------------------
>
>diff -uNr iptables.orig/extensions/libipt_u32.c iptables/extensions/libipt_u32.c
>--- iptables.orig/extensions/libipt_u32.c	Thu Sep  2 14:13:50 2004
>+++ iptables/extensions/libipt_u32.c	Thu Sep  2 13:20:23 2004
>@@ -85,7 +85,7 @@
> 	char *end;
> 	errno = 0;
> 
>-	number = strtol(*s, &end, 0);
>+	number = strtoul(*s, &end, 0);
> 	if (end == *s)
> 		exit_error(PARAMETER_PROBLEM, 
> 			   "u32: at char %d expected number", pos);
>  
>
