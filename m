From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: iptables release
Date: Thu, 29 Nov 2007 15:00:38 +0900 (JST)
Message-ID: <200711290600.lAT60d7w022168@toshiba.co.jp>
References: <474C4B67.3000200@trash.net>
	<200711290249.lAT2nk9g004082@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org
To: yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from imx9.toshiba.co.jp ([202.33.96.51]:37131 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbXK2Gal (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:30:41 -0500
Received: from inet-tsb5.toshiba.co.jp (inet-tsb5 [202.33.96.24])
	by imx9.toshiba.co.jp  with ESMTP id lAT6UdmB024886
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 15:30:40 +0900 (JST)
Received: from arc1.toshiba.co.jp ([133.199.194.235])
	by inet-tsb5.toshiba.co.jp  with ESMTP id lAT60eam009708
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 15:00:40 +0900 (JST)
Received: (from root@localhost)
	by arc1.toshiba.co.jp  id lAT60efl009861
	for netfilter-devel@vger.kernel.org; Thu, 29 Nov 2007 15:00:40 +0900 (JST)
Received: from mx12.toshiba.co.jp (localhost [127.0.0.1])
	by ovp1.toshiba.co.jp  with ESMTP id lAT60eww000836
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Nov 2007 15:00:40 +0900 (JST)
In-Reply-To: <200711290249.lAT2nk9g004082@toshiba.co.jp>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Patrick,

From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>

> Please wait a few hours at least to release iptables. Just after sending
> this mail, I'll moves some libipt_*.man to libxt_*.man and remove
> libip6t_state.c which I forgot to remove.

Done.

- I've moved following libipt_*.man to libxt_*.man where libxt_*.c.
  exists and libip6t_*.man does not exist.

	CLASSIFY, CONNMARK, CONNSECMARK, DSCP, NOTRACK, comment, connbytes,
	connmark, dccp, dscp, hashlimit, helper, pkttype, quota, sctp,
	state, string, tcpmss

- I've unified libipt_*.man and libip6t_*.man into libxt_*.man where they
  have no difference and libxt_*.c exists.

	NFQUEUE, SECMARK, esp, limit, mac, mark, physdev, udp

- I've removed libip6t_state.c and libip6t_u32.man. libxt_* for them
  exist.

- I've fixed typo in extensions/Makefile as follows. Now selinux related
  modules would be correctly build by DO_SELINUX=1.

Index: extensions/Makefile
===================================================================
--- extensions/Makefile	(revision 7127)
+++ extensions/Makefile	(revision 7128)
@@ -15,8 +15,8 @@
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
-PF6_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
-PFX_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
+PF6_EXT_SE_SLIB:=$(PF6_EXT_SELINUX_SLIB)
+PFX_EXT_SE_SLIB:=$(PFX_EXT_SELINUX_SLIB)
 endif
 
 # Optionals

Regards,

-- Yasuyuki Kozakai
