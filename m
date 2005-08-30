From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH 2/3] CLUSTERIP: introduce reference counting for entries
Date: Tue, 30 Aug 2005 17:26:07 +0200
Message-ID: <200508301726.08506@nienna>
References: <20050830121535.985929000@nienna.balabit>
	<20050830121550.397433000@nienna.balabit>
	<20050830140740.GC4221@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050830140740.GC4221@rama.de.gnumonks.org>
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


  Hi,

On Tuesday 30 August 2005 16.07, Harald Welte wrote:
> Thanks for your patches 2 and 3.  I want to review them in more
> detail and need to re-read the CLUSTERIP code first.  Expect some
> feedback in the next two days.

  OK, thanks. BTW, I've just found a serious bug in patch 2, I knew I
was missing something... So please apply this on top of patch 2.

Index: linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.13.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 
16:59:07.702210333 +0200
+++ linux-2.6.13/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-08-30 
16:50:27.431088379 +0200
@@ -444,6 +444,7 @@
 	 * attached, simply increase the entry refcount and return */
 	if (cipinfo->config != NULL) {
 		clusterip_config_entry_get(cipinfo->config);
+                clusterip_config_get(cipinfo->config);
 		return 1;
 	}

-- 
 Regards,
  Krisztian Kovacs
