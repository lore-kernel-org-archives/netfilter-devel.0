From: Matthew Strait <quadong@users.sourceforge.net>
Subject: Re: childlevel's pom comment
Date: Wed, 3 Mar 2004 22:44:35 -0600 (CST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.60.0403032150000.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
References: <Pine.LNX.4.60.0403031947450.8957@dsl093-017-216.msp1.dsl.speakeasy.net>
 <40469E10.7080100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <40469E10.7080100@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I'm going to add your updated help-text. But I have doubts about whether
> a new match is required at all. A connection can only have a childlevel
> of one because only masters have helpers assigned to them, although in
> theory the expect-function could register more expectations. So you can
> basically match if a connection was expected or not. The same can also
> be achieved by a trivial change to the helper match, just allow
> zero-string length and use them as a special value. This should also
> allow full userspace compatibility. What do you think ?

Sounds like a good idea.  The only variation I'd make is to have the
helper match take "any" as the special value, because it's hard to pass an
empty string to iptables.  (Trying to pass "" gets you an error message
and trying to pass \"\" ends up giving the module literal quotation marks.
If I'm missing something obvious, let me know.  Here are the changes
needed in the kernel:

--- ipt_helper.c.old    2004-03-03 21:34:05.625216688 -0600
+++ ipt_helper.c        2004-03-03 22:32:06.239867656 -0600
@@ -48,7 +48,7 @@

        if (!ct->master) {
                DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
-               return 0;
+               return info->invert;
        }

        exp = ct->master;
@@ -68,8 +68,11 @@
        DEBUGP("master's name = %s , info->name = %s\n",
                exp->expectant->helper->name, info->name);

-       ret = !strncmp(exp->expectant->helper->name, info->name,
-                      strlen(exp->expectant->helper->name)) ^
info->invert;
+       if(!strcmp(info->name, "any"))
+               ret = 1 ^ info->invert;
+       else
+               ret = !strncmp(exp->expectant->helper->name, info->name,
+                              strlen(exp->expectant->helper->name)) ^
info->invert;
 out_unlock:
        READ_UNLOCK(&ip_conntrack_lock);
        return ret;


I have to change the 0 to info->invert so that "! --helper any" means
"packets that aren't from any helper".  With the 0, that rule would never
match.  It seems to me that this is the correct behavior even without
adding the "any" special case.  If I ask for "! --helper ftp", I would
expect master packets to match, because they are not from an ftp helper.

Trivial documentational changes in userspace:

--- libipt_helper.c.old 2004-03-03 21:39:07.255361936 -0600
+++ libipt_helper.c     2004-03-03 21:52:10.838861040 -0600
@@ -15,6 +15,7 @@
        printf(
 "helper match v%s options:\n"
 "[!] --helper string        Match helper identified by string\n"
+"                           (or any helper if string is "any")\n"
 "\n",
 IPTABLES_VERSION);
 }

--- iptables.8.old      2004-03-03 22:18:55.017383552 -0600
+++ iptables.8  2004-03-03 22:20:43.137999928 -0600
@@ -458,6 +458,8 @@
 For other ports append -portnr to the value, ie. "ftp-2121".
 .PP
 Same rules apply for other conntrack-helpers.
+.PP
+Use "any" to match any helper.
 .RE
 .SS icmp
 This extension is loaded if `--protocol icmp' is specified.  It




If this patch is accepted, I don't see any reason to keep childlevel in
patch-o-matic.

-matthew
