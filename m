From: Harald Welte <laforge@gnumonks.org>
Subject: [marcus@ingate.com: [PATCH] Iptables multiport match fix]
Date: Wed, 10 Jul 2002 10:38:41 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020710083841.GM23676@naboo.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gDGSpKKIBgtShtf+"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--gDGSpKKIBgtShtf+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--gDGSpKKIBgtShtf+
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Received: from vger.kernel.org ([209.116.70.75])
	by coruscant.gnumonks.org with esmtp (Exim 3.34 #1)
	id 17S1Wk-00082r-00
	for laforge@gnumonks.org; Tue, 09 Jul 2002 22:24:02 +0200
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id <S317397AbSGIUTK>; Tue, 9 Jul 2002 16:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org
	id <S317398AbSGIUTJ>; Tue, 9 Jul 2002 16:19:09 -0400
Received: from [213.187.195.158] ([213.187.195.158]:48368 "EHLO
	kokeicha.ingate.se") by vger.kernel.org with ESMTP
	id <S317397AbSGIUTI>; Tue, 9 Jul 2002 16:19:08 -0400
Received: from inigo.ingate.se (mail@inigo.ingate.se [10.48.8.2])
	by kokeicha.ingate.se (8.11.6/8.11.6) with ESMTP id g69KLbf27393;
	Tue, 9 Jul 2002 22:21:37 +0200
Received: from marcus by inigo.ingate.se with local (Exim 3.35 #1 (Debian))
	id 17S1UO-0001Ec-00; Tue, 09 Jul 2002 22:21:36 +0200
To: netfilter-devel@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Iptables multiport match fix
From: Marcus Sundberg <marcus@ingate.com>
Date: 09 Jul 2002 22:21:36 +0200
Message-ID: <veznx0ejov.fsf@inigo.ingate.se>
User-Agent: Gnus/5.0808 (Gnus v5.8.8) Emacs/20.7
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The multiport match checks for the IPT_INV_PROTO flag in the 'flags'
member of struct ipt_ip instead of in the 'invflags' member.

diff -ur linux.current/net/ipv4/netfilter/ipt_multiport.c linux-mine/net/ipv4/netfilter/ipt_multiport.c
--- linux-2.4.19-rc1/net/ipv4/netfilter/ipt_multiport.c	Tue Jun 20 23:32:27 2000
+++ linux/net/ipv4/netfilter/ipt_multiport.c	Tue Jul  9 10:43:23 2002
@@ -78,7 +78,7 @@
 
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
-		&& !(ip->flags & IPT_INV_PROTO)
+		&& !(ip->invflags & IPT_INV_PROTO)
 		&& matchsize == IPT_ALIGN(sizeof(struct ipt_multiport))
 		&& (multiinfo->flags == IPT_MULTIPORT_SOURCE
 		    || multiinfo->flags == IPT_MULTIPORT_DESTINATION

(Where should I send this btw? The kernel part of iptables doesn't
seem to be in the netfilter CVS. Was I supposed to create a p-o-m
patch? Or send it directly to Marcelo?)

//Marcus
-- 
---------------------------------------+--------------------------
  Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
 Firewall Developer, Ingate Systems AB |  http://www.ingate.com/
-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/


--gDGSpKKIBgtShtf+--
