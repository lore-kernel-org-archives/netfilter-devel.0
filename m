From: quadong@users.sourceforge.net
Subject: [PATCH] ipt_helper.c
Date: Thu, 4 Mar 2004 14:42:16 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0403041439110.10634@dsl093-017-216.msp1.dsl.speakeasy.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently, if you tell iptables to match "-m helper ! --helper ftp" it
will match any packet from any helper other than FTP.  What it should do
is match any packet that is not from an FTP helper, included packets that
are not from any helper (packets from master connections).  Here's the
fix:

--- ipt_helper.c.old    2004-03-03 21:34:05.000000000 -0600
+++ ipt_helper.c        2004-03-04 14:34:17.709903456 -0600
@@ -48,7 +48,7 @@

        if (!ct->master) {
                DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
-               return 0;
+               return info->invert;
        }

        exp = ct->master;
