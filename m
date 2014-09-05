From: Florian Westphal <fw@strlen.de>
Subject: Re: iptables: missing connlabel.conf causes unnecessary error
 messages
Date: Fri, 5 Sep 2014 11:13:05 +0200
Message-ID: <20140905091305.GB934@breakpoint.cc>
References: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Thomas De Schampheleire <patrickdepinguin@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:57892 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828AbaIEJNH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:13:07 -0400
Content-Disposition: inline
In-Reply-To: <CAAXf6LW4zfxOMeUO4=UPFUX=0VGjLbM_wKhdb3L7DK4SPBmbhg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas De Schampheleire <patrickdepinguin@gmail.com> wrote:
> Commit http://git.netfilter.org/iptables/commit/?id=51340f7b6a1103b12d86ef488f7140406d80401e
> removed the default /etc/xtables/connlabel.conf file distributed with netfilter.
> 
> From this commit onwards, every call to iptables will show the message:
>     cannot open connlabel.conf, not registering 'connlabel' match: No
> such file or directory

Right, this happens for static builds.

> Creating an empty connlabel.conf file does not really help, the
> message now becomes:
>     cannot open connlabel.conf, not registering 'connlabel' match: Success

Thats a bug.

> Moreover, I do not understand the reasoning of the mentioned commit:
> what is the problem in respecting sysconfdir? There are so many
> applications and libraries that use autoconf and can have
> configuration files in a place respecting sysconfdir.

Because then every libnetfiler_conntrack mapping call in
non-iptables software has to 'guess' where iptables' sysconfdir is.

> Finally, even if you do not want to provide a default file with the
> iptables installation, an empty file (created by the user) should hide
> the error message.
> 
> What is your view on this?

Agreed.
If there are no other comments, I will push following patch later today:

connlabel: do not open config file from _init hook

else, static builds will print this for every iptables invocation,
even 'iptables -L'.  Delay opening until we need to translate a mapping.

diff --git a/extensions/libxt_connlabel.c b/extensions/libxt_connlabel.c
--- a/extensions/libxt_connlabel.c
+++ b/extensions/libxt_connlabel.c
@@ -29,11 +29,26 @@ static const struct xt_option_entry connlabel_mt_opts[] = {
 	XTOPT_TABLEEND,
 };
 
+/* cannot do this via _init, else static builds might spew error message
+ * for every iptables invocation.
+ */
+static void connlabel_open(void)
+{
+	if (map)
+		return;
+
+	map = nfct_labelmap_new(NULL);
+	if (!map && errno)
+		xtables_error(RESOURCE_PROBLEM, "cannot open connlabel.conf: %s\n",
+			strerror(errno));
+}
+
 static void connlabel_mt_parse(struct xt_option_call *cb)
 {
 	struct xt_connlabel_mtinfo *info = cb->data;
 	int tmp;
 
+	connlabel_open();
 	xtables_option_parse(cb);
 
 	switch (cb->entry->id) {
@@ -54,7 +69,11 @@ static void connlabel_mt_parse(struct xt_option_call *cb)
 
 static const char *connlabel_get_name(int b)
 {
-	const char *name = nfct_labelmap_get_name(map, b);
+	const char *name;
+
+	connlabel_open();
+
+	name = nfct_labelmap_get_name(map, b);
 	if (name && strcmp(name, ""))
 		return name;
 	return NULL;
@@ -114,11 +133,5 @@ static struct xtables_match connlabel_mt_reg = {
 
 void _init(void)
 {
-	map = nfct_labelmap_new(NULL);
-	if (!map) {
-		fprintf(stderr, "cannot open connlabel.conf, not registering '%s' match: %s\n",
-			connlabel_mt_reg.name, strerror(errno));
-		return;
-	}
 	xtables_register_match(&connlabel_mt_reg);
 }
