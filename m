From: Jan Engelhardt <jengelh@medozas.de>
Subject: Using TRACE with ulogd2
Date: Tue, 6 Jan 2009 11:28:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901061119270.28823@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, sean.donner@gmail.com
To: eric@inl.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58730 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZAFK2p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 05:28:45 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


from discussions on IRC and after looking at the kernel's code, I got 
the impression that xt_TRACE's output can currently not be fed into 
ulogd2, as xt_NFLOG does not make itself available for NF Core logging 
through nf_log_packet() as it does not register with nf_log.c's
nf_log_register().
Could you consider adding this?


Jan
