From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [1/2] osf: fixed matching bug.
Date: Sun, 22 Aug 2004 01:03:53 +0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040822010353.34801a4f@zanzibar.2ka.mipt.ru>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Sun__22_Aug_2004_01_03_53_+0400_5voKYf6utvlQO4/2"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Sun__22_Aug_2004_01_03_53_+0400_5voKYf6utvlQO4/2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Fixed matching bug - when we have match and have options to process
not only first one but all, then we may rewrite fmatch value
with FMATCH_WRONG parameters. Later osf will create decision based on
the latest fmatch value, but not the fact that osf had match before.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

	Evgeniy Polyakov ( s0mbre )

Only failure makes us experts. -- Theo de Raadt

--Multipart=_Sun__22_Aug_2004_01_03_53_+0400_5voKYf6utvlQO4/2
Content-Type: text/plain;
 name="ipt_osf.diff"
Content-Disposition: attachment;
 filename="ipt_osf.diff"
Content-Transfer-Encoding: 7bit

--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c	2004-07-18 00:10:43.000000000 +0400
+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.6/net/ipv4/netfilter/ipt_osf.c	2004-08-20 21:55:22.000000000 +0400
@@ -411,8 +413,11 @@
 		}
 	}
 
-	read_unlock(&osf_lock);
+	if (fcount)
+		fmatch = FMATCH_OK;
 
+	read_unlock(&osf_lock);
+	
 	return (fmatch == FMATCH_OK)?1:0;
 }
 

--Multipart=_Sun__22_Aug_2004_01_03_53_+0400_5voKYf6utvlQO4/2--
