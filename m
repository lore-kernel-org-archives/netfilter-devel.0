From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Wed, 1 Aug 2007 17:02:16 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708011701150.26668@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707241201420.18990@fbirervta.pbzchgretzou.qr>
	<200707310025.l6V0PDOP029552@toshiba.co.jp>
	<Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
	<200708011440.l71EeFXl010903@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200708011440.l71EeFXl010903@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Aug 1 2007 23:40, Yasuyuki KOZAKAI wrote:
>
>The argument 'family' has no effect. And this change makes possible to
>remove links from libxt_*.so to libip[6]t_*.so as you proposed.

Ah indeed.

>index baee483..58b4e81 100644
>--- a/xtables.c
>+++ b/xtables.c
>@@ -292,18 +292,21 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
> 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
> 		char path[strlen(lib_dir) + sizeof("/.so")
> 			  + strlen(afinfo.libprefix) + strlen(name)];
>-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
>-			name);
>-		if (dlopen(path, RTLD_NOW)) {
>+
>+		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
>+		if (dlopen(path, RTLD_NOW) != NULL)

I'd suggest using snprintf(). (Also elsewhere)
But looks ok otherwise.


	Jan
-- 
