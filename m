From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Sat, 04 Aug 2007 12:38:33 +0900 (JST)
Message-ID: <200708040338.l743cYme010888@toshiba.co.jp>
References: <Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
	<200708011440.l71EeFXl010903@toshiba.co.jp>
	<Pine.LNX.4.64.0708011701150.26668@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
To: jengelh@computergmbh.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708011701150.26668@fbirervta.pbzchgretzou.qr>
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


Hi,

From: Jan Engelhardt <jengelh@computergmbh.de>

> On Aug 1 2007 23:40, Yasuyuki KOZAKAI wrote:
> >
> >The argument 'family' has no effect. And this change makes possible to
> >remove links from libxt_*.so to libip[6]t_*.so as you proposed.
> 
> Ah indeed.

Thanks for review. I'll apply that soon.

> >index baee483..58b4e81 100644
> >--- a/xtables.c
> >+++ b/xtables.c
> >@@ -292,18 +292,21 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
> > 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
> > 		char path[strlen(lib_dir) + sizeof("/.so")
> > 			  + strlen(afinfo.libprefix) + strlen(name)];
> >-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
> >-			name);
> >-		if (dlopen(path, RTLD_NOW)) {
> >+
> >+		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
> >+		if (dlopen(path, RTLD_NOW) != NULL)
> 
> I'd suggest using snprintf(). (Also elsewhere)
> But looks ok otherwise.

I didn't notice that. But why snprintf is necessary here ? We have always
enough space for path[].

Are you afraid of buffer overflow due to incorrect size of path[] ?
If so, we'd also better to check return value of snprintf().

-- Yasuyuki Kozakai
