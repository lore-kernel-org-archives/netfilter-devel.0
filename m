From: "Neville D/Netfilter" <NevilleD.NetFilter@sgr-a.net>
Subject: patch/ipset: fix typo in ipset error msg: "Range to large. Max is
	%d IPs in range\n"
Date: Wed, 15 Aug 2007 13:53:39 +1000
Message-ID: <cfd808ce0708142053j7780cf7jc771be2910a4aba5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi Pablo & others,

Here is a super minor patch.

Request for clemency in advance if there is a better way to submitting
such tiny patches... a branch?

I am also reading some of the ipset's docs and would be happy to
commit typo fixes once I have finished.

Pls advise

Regards
NevilleD

$ svn diff netfilter/trunk/ipset
Index: netfilter/trunk/ipset/ipset_ipmap.c
===================================================================
--- netfilter/trunk/ipset/ipset_ipmap.c (revision 7008)
+++ netfilter/trunk/ipset/ipset_ipmap.c (working copy)
@@ -191,7 +191,7 @@
       }
       if (range > MAX_RANGE)
               exit_error(PARAMETER_PROBLEM,
-                          "Range to large. Max is %d IPs in range\n",
+                          "Range too large. Max is %d IPs in range\n",
                          MAX_RANGE+1);
 }

Index: netfilter/trunk/ipset/ipset_ipporthash.c
===================================================================
--- netfilter/trunk/ipset/ipset_ipporthash.c    (revision 7008)
+++ netfilter/trunk/ipset/ipset_ipporthash.c    (working copy)
@@ -181,7 +181,7 @@

       if (mydata->to - mydata->from > MAX_RANGE)
               exit_error(PARAMETER_PROBLEM,
-                          "Range to large. Max is %d IPs in range\n",
+                          "Range too large. Max is %d IPs in range\n",
                          MAX_RANGE+1);
 }
