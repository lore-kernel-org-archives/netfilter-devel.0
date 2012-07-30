From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv,
 cleanup (fix gcc-4.7)
Date: Mon, 30 Jul 2012 03:37:07 +0200
Message-ID: <20120730013707.GA2350@1984>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
 <1343042946.2626.10727.camel@edumazet-glaptop>
 <1343043528.2626.10755.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="envbJBWh7q8WU6mo"
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1343043528.2626.10755.camel@edumazet-glaptop>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 23, 2012 at 01:38:48PM +0200, Eric Dumazet wrote:
> On Mon, 2012-07-23 at 13:29 +0200, Eric Dumazet wrote:
> > On Mon, 2012-07-23 at 12:38 +0200, pablo@netfilter.org wrote:
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > 
> > > This patch seems to be a mere cleanup that moves the parameter parsing
> > > code to add_param_to_argv.
> > > 
> > > But, in reality, it also fixes iptables whe compiled with gcc-4.7.
> > > 
> > > Moving param_buffer declaration out of the loop seems to resolve the
> > > issue. gcc-4.7 seems to be generating bad code regarding param_buffer.
> > > 
> > > @@ -380,9 +380,9 @@
> > >                         quote_open = 0;
> > >                         escaped = 0;
> > >                         param_len = 0;
> > > +                       char param_buffer[1024];
> > > 
> > >                         for (curchar = parsestart; *curchar; curchar++) {
> > > -                               char param_buffer[1024];
> > > 
> > >                                 if (quote_open) {
> > >                                         if (escaped) {
> > > 
> > > But I have hard time to apply this patch in such a way. Instead, I came
> > > up with the idea of this cleanup, which does not harm after all (and fixes
> > > the issue for us).
> > > 
> > > Sorry, I didn't have the time to further debug this issue, but it would be
> > > worth to investigate what's going wrong and ping gcc people.
> > 
> > Bug seems that iptables forgot that "char param_buffer[1024];" can
> > disappear at the end of the block :
> > 
> > for (curchar = parsestart; *curchar; curchar++) {
> > 	char param_buffer[1024];
> > 	...
> > }
> > 
> > // here param_buffer[1024] is lost, so any var pointing 
> > // to it can mess stack
> > 
> > previous gcc were probably not so aggressive.
> 
> Oh well, add_argv() does a strdup(), so iptables code seems fine.

I thought the same, but one contributor has put some on light on this.

I'm going to revert the patch that I applied to fix this and apply
the one that comes with this email instead.

It contains a simple description of the problem, I think it's good for
the record (distro maintainers will likely google for this).

--envbJBWh7q8WU6mo
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-iptables-restore-fix-memory-corruption-in-parameter-.patch"

>From 8cfcb0137f4aee880ec749cd2356148325f6085d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 30 Jul 2012 03:08:51 +0200
Subject: [PATCH] iptables-restore: fix memory corruption in parameter parsing
 with gcc-4.7

This patch fixes a memory corruption that has been in iptables-restore since
time ago. The problem has shown up with gcc-4.7. This version of gcc seem to
perform more agressive memory management than previous.

Peter Lekensteyn provided the following sample code similar to the one
in iptables-restore:

int i = 0;

for (;;) {
	char x[5];

	x[i] = '0' + i;
	if (++i == 4) {
		x[i] = '\0'; /* terminate string with null byte */
		printf("%s\n", x);
		break;
	}
}

Many may expect 0123 as output. But GCC 4.7 does not do that when compiling
with optimization enabled (-O1 and higher). It instead puts random data in the
first bytes of the character array, which becomes:

| 0  |  1  |  2  |  3  |  4   |
|     RANDOM     | '3' | '\0' |

Since the array is declared inside the scope of loop's body, you can think of
it as of a new array being allocated in the automatic storage area for each
loop iteration.

The correct code should be:

char x[5];

for (;;) {
	x[i] = '0' + i;
	if (++i == 4) {
		x[i] = '\0'; /* terminate string with null byte */
		printf("%s\n", x);
		break;
	}
}

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/ip6tables-restore.c |    3 +--
 iptables/iptables-restore.c  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables-restore.c b/iptables/ip6tables-restore.c
index 3894d68..1ec3dd9 100644
--- a/iptables/ip6tables-restore.c
+++ b/iptables/ip6tables-restore.c
@@ -329,6 +329,7 @@ int ip6tables_restore_main(int argc, char *argv[])
 			char *curchar;
 			int quote_open, escaped;
 			size_t param_len;
+			char param_buffer[1024];
 
 			/* reset the newargv */
 			newargc = 0;
@@ -379,8 +380,6 @@ int ip6tables_restore_main(int argc, char *argv[])
 			param_len = 0;
 
 			for (curchar = parsestart; *curchar; curchar++) {
-				char param_buffer[1024];
-
 				if (quote_open) {
 					if (escaped) {
 						param_buffer[param_len++] = *curchar;
diff --git a/iptables/iptables-restore.c b/iptables/iptables-restore.c
index 034f960..9f51f99 100644
--- a/iptables/iptables-restore.c
+++ b/iptables/iptables-restore.c
@@ -329,6 +329,7 @@ iptables_restore_main(int argc, char *argv[])
 			char *curchar;
 			int quote_open, escaped;
 			size_t param_len;
+			char param_buffer[1024];
 
 			/* reset the newargv */
 			newargc = 0;
@@ -379,8 +380,6 @@ iptables_restore_main(int argc, char *argv[])
 			param_len = 0;
 
 			for (curchar = parsestart; *curchar; curchar++) {
-				char param_buffer[1024];
-
 				if (quote_open) {
 					if (escaped) {
 						param_buffer[param_len++] = *curchar;
-- 
1.7.10.4


--envbJBWh7q8WU6mo--
