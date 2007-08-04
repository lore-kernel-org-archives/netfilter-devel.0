From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 01/**] libxt_*.so lookup
Date: Sat, 4 Aug 2007 10:25:59 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708041021150.11760@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707310958360.22515@fbirervta.pbzchgretzou.qr>
	<200708011440.l71EeFXl010903@toshiba.co.jp>
	<Pine.LNX.4.64.0708011701150.26668@fbirervta.pbzchgretzou.qr>
	<200708040338.l743cY1U010811@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200708040338.l743cY1U010811@toshiba.co.jp>
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


On Aug 4 2007 12:38, Yasuyuki KOZAKAI wrote:
>> >index baee483..58b4e81 100644
>> >--- a/xtables.c
>> >+++ b/xtables.c
>> >@@ -292,18 +292,21 @@ struct xtables_match *find_match(const char *name, enum xt_tryload tryload,
>> > 	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
>> > 		char path[strlen(lib_dir) + sizeof("/.so")
>> > 			  + strlen(afinfo.libprefix) + strlen(name)];
>> >-		sprintf(path, "%s/%s%s.so", lib_dir, afinfo.libprefix,
>> >-			name);
>> >-		if (dlopen(path, RTLD_NOW)) {
>> >+
>> >+		sprintf(path, "%s/libxt_%s.so", lib_dir, name);
>> >+		if (dlopen(path, RTLD_NOW) != NULL)
>> 
>> I'd suggest using snprintf(). (Also elsewhere)
>> But looks ok otherwise.
>
>I didn't notice that. But why snprintf is necessary here ? We have always
>enough space for path[].

Better safe than sorry. Right, when you path[strlen...] it of course
suffices, but then again you could just write path[PATH_MAX],
because POSIX does not do longer names anyway.

BTW, there is a bug, which is why snprintf _is_ good after all:

>> > 		char path[strlen(lib_dir) + sizeof("/.so")
>> > 			  + strlen(afinfo.libprefix) + strlen(name)];

strlen("libxt_") might be larger than strlen(afinfo.libprefix).

>Are you afraid of buffer overflow due to incorrect size of path[] ?
>If so, we'd also better to check return value of snprintf().

Possible, but not really needed. If the name was truncated, then
dlopen() will fail and the user wonders "wtf - this is impossible"
and can report the bug.


	Jan
-- 
