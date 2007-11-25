From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/4] iptables: move manpage
Date: Sun, 25 Nov 2007 02:06:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711250205420.25644@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35702 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXKYBGY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 20:06:24 -0500
In-Reply-To: <Pine.LNX.4.64.0711250204360.25644@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Rename libipt_{time,u32}.man to libxt_{time,u32}.man to go
in line with the C files.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/lib{ip => x}t_time.man (100% similar)
 extensions/lib{ip => x}t_u32.man (100% similar)
 4 files changed

# This is the patch. You have to do the `svn mv`.
