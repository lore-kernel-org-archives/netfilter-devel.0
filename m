From: Pawel Sikora <pluto@agmk.net>
Subject: Re: [PATCH] Another save/restore buglet
Date: Fri, 20 May 2005 12:40:35 +0200
Message-ID: <200505201240.36175.pluto@agmk.net>
References: <428BCB6E.1020709@shorewall.net>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_k6bjCmjamumGHMz"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <428BCB6E.1020709@shorewall.net>
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

--Boundary-00=_k6bjCmjamumGHMz
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 19 of May 2005 01:10, Tom Eastep wrote:
> This time, it's the CONNMARK extention that is producing saved output
> that won't restore.
>
> gateway:/etc/test# iptables-save > save
> gateway:/etc/test# iptables-restore < save
> iptables-restore v1.3.1: Bad MASK value `ff'
> Error occurred at line: 24
> Try `iptables-restore -h' or 'iptables-restore --help' for more
> information. gateway:/etc/test#
>
> Patch attached.

You've missed the 64-bit variant ;-)

-- 
The only thing necessary for the triumph of evil
  is for good men to do nothing.
                                           - Edmund Burke

--Boundary-00=_k6bjCmjamumGHMz
Content-Type: text/x-diff; charset="iso-8859-2"; name="libipt_CONNMARK.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="libipt_CONNMARK.c.diff"

Index: libipt_CONNMARK.c
===================================================================
--- libipt_CONNMARK.c	(revision 5883)
+++ libipt_CONNMARK.c	(working copy)
@@ -150,7 +150,7 @@
 print_mask(const char *text, unsigned long long mask)
 {
 	if (mask != ~0ULL)
-		printf("%s%llx", text, mask);
+		printf("%s0x%llx", text, mask);
 }
 
 #else
@@ -165,7 +165,7 @@
 print_mask(const char *text, unsigned long mask)
 {
 	if (mask != ~0UL)
-		printf("%s%lx", text, mask);
+		printf("%s0x%lx", text, mask);
 }
 #endif
 

--Boundary-00=_k6bjCmjamumGHMz--
