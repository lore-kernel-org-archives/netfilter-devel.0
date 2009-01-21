From: =?utf-8?q?K=C3=B6vesdi_Gy=C3=B6rgy?= <kgy@teledigit.hu>
Subject: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 10:29:01 +0100
Message-ID: <200901211029.01619.kgy@teledigit.hu>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fxip-0059e.externet.hu ([88.209.247.158]:50478 "EHLO
	teledigit.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761886AbZAUJj1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 04:39:27 -0500
Received: from kgy-wifi.deverto.office ([195.70.47.5]:45505)
	by teledigit.hu with [XMail 1.25 ESMTP Server]
	id <S641> for <netfilter-devel@vger.kernel.org> from <kgy@teledigit.hu>;
	Wed, 21 Jan 2009 10:31:04 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The new netlink interface allows to add NAT directly to a conntrack entry.
If it is used when the moudule nf-nat-ipv4 is not loaded in, it results in 
crash:
BUG: scheduling while atomic
It is in the kernels 2.6.28 and 2.6.28.1 in the function 
ctnetlink_parse_nat_setup(): it calls request_module() which causes the 
problem. If the module is already loaded, then there is no problem.

Regards:
K. Gy.
