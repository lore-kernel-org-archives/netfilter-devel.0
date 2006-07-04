From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] icmpv6 match --icmpv6-type confusion
Date: Tue, 04 Jul 2006 13:26:11 +0900 (JST)
Message-ID: <200607040426.k644QClo003412@toshiba.co.jp>
References: <44A95957.4040805@trash.net>
	<200607040030.k640U4e5004273@toshiba.co.jp>
	<44A9BA71.2050303@trash.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Jul__4_13_26_11_2006_933)--"
Content-Transfer-Encoding: 7bit
Cc: kernel@linuxace.com, netfilter-devel@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <44A9BA71.2050303@trash.net>
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

----Next_Part(Tue_Jul__4_13_26_11_2006_933)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 04 Jul 2006 02:46:41 +0200

> Yasuyuki KOZAKAI wrote:
> > From: Patrick McHardy <kaber@trash.net>
> > Subject: Re: [PATCH] icmpv6 match --icmpv6-type confusion
> > Date: Mon, 03 Jul 2006 19:52:23 +0200
> >>Phil Oester wrote:
> >>
> >>>Adding a rule such as this:
> >>>
> >>>-A INPUT -p ipv6-icmp -m icmpv6
> >>>
> >>>ends up creating a rule with "ipv6-icmp type 0", instead of "ipv6-icmp type any"
> >>>which is what was expected.  Granted, the match is redundant anyway, but it
> >>>should not assume a specific type when one is not specified.
> >>>
> >>>Below patches (to both kernel and userspace) fix this, and resolve bug #461.
> >>>In keeping with icmpv4, 0xFF is used to designate "any". And since I was
> >>>looking at it, I fixed up a 255 -> any in icmpv4 printing.
> >>
> >>Thanks Phil. I have to admit that I never liked the ugly 255 hack,
> >>its a perfectly valid value for the type field to use, even though
> >>its currently not defined for IPv4 or IPv6. For IPv6 I even have
> >>some concerns that it will stay unused for all times, the stategy
> >>for choosing new values seems to be different from IPv4. I guess
> >>an alternative would be to introduce a new revision.
> >>
> >>Yasuyuki, do you have an opinion on this?
> > 
> > 
> > It sounds good to me to introduce a new revision and a new value to support
> > "icmpv6-type any". But can we really break behavior compatibility of
> > "-p ipv6-icmp -m icmpv6" ?
> 
> 
> I tend to agree with Phil's interpretation that this is actually
> unexpected behaviour, so I don't think anyone is doing this
> intentional. I would expect either a parser error or type any.

parser error is good idea. It's not neccesary for icmpv6 match to support
"--icmpv6-type any" because people can get same behavior with only
"-p ipv6-icmp".

How about the attached patch ? That also fixes allowing double
--icmp-type/--icmpv6-type.

-- Yasuyuki Kozakai


----Next_Part(Tue_Jul__4_13_26_11_2006_933)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="icmp.patch"

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index a29bb38..6940d0e 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -164,11 +164,15 @@ parse(int c, char **argv, int invert, un
 
 	switch (c) {
 	case '1':
+		if (*flags == 1)
+			exit_error(PARAMETER_PROBLEM,
+				   "icmpv6 match: only use --icmpv6-type once!");
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
 			     icmpv6info->code);
 		if (invert)
 			icmpv6info->invflags |= IP6T_ICMP_INV;
+		*flags = 1;
 		break;
 
 	default:
@@ -247,9 +251,11 @@ static void save(const struct ip6t_ip6 *
 	printf(" ");
 }
 
-/* Final check; we don't care. */
 static void final_check(unsigned int flags)
 {
+	if (!flags)
+		exit_error(PARAMETER_PROBLEM,
+			   "icmpv6 match: You must specify `--icmpv6-type'");
 }
 
 static struct ip6tables_match icmpv6 = {
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 9d45c8c..8f22d05 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -189,11 +189,15 @@ parse(int c, char **argv, int invert, un
 
 	switch (c) {
 	case '1':
+		if (*flags == 1)
+			exit_error(PARAMETER_PROBLEM,
+				   "icmp match: only use --icmp-type once!");
 		check_inverse(optarg, &invert, &optind, 0);
 		parse_icmp(argv[optind-1], &icmpinfo->type, 
 			   icmpinfo->code);
 		if (invert)
 			icmpinfo->invflags |= IPT_ICMP_INV;
+		*flags = 1;
 		break;
 
 	default:

----Next_Part(Tue_Jul__4_13_26_11_2006_933)----
