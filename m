From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Problem: ip_nat_irc.c in kernel 2.6.11.5
Date: Tue, 22 Mar 2005 01:00:01 +1100
Message-ID: <1111413602.27471.17.camel@localhost.localdomain>
References: <a17b2e290503200056455a42d6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Andy K <crap.goes.here@gmail.com>
In-Reply-To: <a17b2e290503200056455a42d6@mail.gmail.com>
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

On Sun, 2005-03-20 at 00:56 -0800, Andy K wrote:
> Hello,
> 
> I recently upgraded my system from kernel 2.6.7 to 2.6.11.5 and have
> found that my DCC transfers no longer work inside my NAT'd network. It
> appears that the ip_nat_irc.c code no longer takes a 'ports'
> parameter, although it did in 2.6.7.

Yes.  (CC'd lkml so google gets a sniff of this in future).

Linus, please apply.
Rusty.

Name: Restore ports module parameter for ip_nat_ftp and ip_nat_irc
Status: Tested on 2.6.12-rc1-bk1
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

There is no "ports" parameter for the ip_nat_ftp and ip_nat_irc
modules in 2.6.11: the ports parameter supplied to the
ip_conntrack_ftp/ip_conntrack_irc module defines the ports.  It was
unfortunate that we were lazy in the original implementation, and
forced the user to duplicate the arguments.

Even more unfortunate, the removal of the parameter caused autoloading
to break for various setups, with an "Unknown parameter" message.  The
solution is to restore the parameter as a dummy, with a polite warning
message that it is no longer neccessary.

Index: linux-2.6.12-rc1-bk1-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c
===================================================================
--- linux-2.6.12-rc1-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_ftp.c	2005-03-02 23:28:18.000000000 +1100
+++ linux-2.6.12-rc1-bk1-Netfilter/net/ipv4/netfilter/ip_nat_ftp.c	2005-03-22 00:40:40.000000000 +1100
@@ -170,5 +170,14 @@
 	return 0;
 }
 
+/* Prior to 2.6.11, we had a ports param.  No longer, but don't break users. */
+static int warn_set(const char *val, struct kernel_param *kp)
+{
+	printk(KERN_INFO __stringify(KBUILD_MODNAME)
+	       ": kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
+	return 0;
+}
+module_param_call(ports, warn_set, NULL, NULL, 0);
+
 module_init(init);
 module_exit(fini);
Index: linux-2.6.12-rc1-bk1-Netfilter/net/ipv4/netfilter/ip_nat_irc.c
===================================================================
--- linux-2.6.12-rc1-bk1-Netfilter.orig/net/ipv4/netfilter/ip_nat_irc.c	2005-03-02 23:28:18.000000000 +1100
+++ linux-2.6.12-rc1-bk1-Netfilter/net/ipv4/netfilter/ip_nat_irc.c	2005-03-22 00:40:33.000000000 +1100
@@ -112,5 +112,14 @@
 	return 0;
 }
 
+/* Prior to 2.6.11, we had a ports param.  No longer, but don't break users. */
+static int warn_set(const char *val, struct kernel_param *kp)
+{
+	printk(KERN_INFO __stringify(KBUILD_MODNAME)
+	       ": kernel >= 2.6.10 only uses 'ports' for conntrack modules\n");
+	return 0;
+}
+module_param_call(ports, warn_set, NULL, NULL, 0);
+
 module_init(init);
 module_exit(fini);

-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
