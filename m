From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Cleanup ttl match option parsing
Date: Sun, 22 Aug 2004 10:38:56 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040822173856.GA20772@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The below patch allows the ttl match to be used with other matches
without assuming it 'owns' all options.  For example, this command
currently causes the '...TTL option twice error':

iptables -A foo -d 1.2.3.4 -m ttl --ttl-eq 1 -m state --state NEW -j ACCEPT

But works with the below patch.

This fixes bugzilla #183

Phil



diff -ru ipt-orig/extensions/libipt_ttl.c ipt-new/extensions/libipt_ttl.c
--- ipt-orig/extensions/libipt_ttl.c    2002-05-29 09:08:16.000000000 -0400
+++ ipt-new/extensions/libipt_ttl.c     2004-08-22 13:07:01.161108504 -0400
@@ -40,10 +40,6 @@
        check_inverse(optarg, &invert, &optind, 0);
        value = atoi(argv[optind-1]);
 
-       if (*flags) 
-               exit_error(PARAMETER_PROBLEM, 
-                               "Can't specify TTL option twice");
-
        if (!optarg)
                exit_error(PARAMETER_PROBLEM,
                                "ttl: You must specify a value");
@@ -56,8 +52,6 @@
 
                        /* is 0 allowed? */
                        info->ttl = value;
-                       *flags = 1;
-
                        break;
                case '3':
                        if (invert) 
@@ -66,8 +60,6 @@
 
                        info->mode = IPT_TTL_LT;
                        info->ttl = value;
-                       *flags = 1;
-
                        break;
                case '4':
                        if (invert)
@@ -76,14 +68,17 @@
 
                        info->mode = IPT_TTL_GT;
                        info->ttl = value;
-                       *flags = 1;
-
                        break;
                default:
                        return 0;
 
        }
 
+       if (*flags) 
+               exit_error(PARAMETER_PROBLEM, 
+                               "Can't specify TTL option twice");
+       *flags = 1;
+
        return 1;
 }
 
