From: Phil Oester <kernel@linuxace.com>
Subject: Re: linux 3.12 regression - snat problem with ftp helper
Date: Fri, 15 Nov 2013 12:09:29 -0800
Message-ID: <20131115200928.GA11322@home>
References: <52862618.4030202@netart.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Cc: netfilter-devel@vger.kernel.org
To: "Dawid Stawiarski - nazwa.pl" <dawid.stawiarski@netart.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51113 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753303Ab3KOUJb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Nov 2013 15:09:31 -0500
Received: by mail-pd0-f179.google.com with SMTP id r10so982814pdi.24
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Nov 2013 12:09:30 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <52862618.4030202@netart.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 15, 2013 at 02:48:08PM +0100, Dawid Stawiarski - nazwa.pl wrote:
> hello,
> 
> after upgrade to mainline kernel v. 3.12 our machines are not able
> to connect to ftp service (from inside of the lxc containters).
> Mainline kernel 3.11.8 works fine.
> 
> in packet 8 host sends rewriten PORT command (with changed private
> to public IP) - however the packet has incorrect sequence number
> (should have 41).
> the ftp server responds with SACK but the host resets the connection.

Does the attached patch solve the problem for you?

Phil



--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-seqadj

diff --git a/net/netfilter/nf_conntrack_seqadj.c b/net/netfilter/nf_conntrack_seqadj.c
index 5f9bfd0..17c1bcb 100644
--- a/net/netfilter/nf_conntrack_seqadj.c
+++ b/net/netfilter/nf_conntrack_seqadj.c
@@ -41,8 +41,8 @@ int nf_ct_seqadj_set(struct nf_conn *ct, enum ip_conntrack_info ctinfo,
 	spin_lock_bh(&ct->lock);
 	this_way = &seqadj->seq[dir];
 	if (this_way->offset_before == this_way->offset_after ||
-	    before(this_way->correction_pos, seq)) {
-		this_way->correction_pos = seq;
+	    before(this_way->correction_pos, ntohl(seq))) {
+		this_way->correction_pos = ntohl(seq);
 		this_way->offset_before	 = this_way->offset_after;
 		this_way->offset_after	+= off;
 	}

--pf9I7BMVVzbSWLtt--
