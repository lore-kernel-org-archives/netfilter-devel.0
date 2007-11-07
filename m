From: krcmar@datinel.cz
Subject: Allow MARK in other tables?
Date: Wed, 7 Nov 2007 17:36:48 +0100
Message-ID: <20071107163647.GA5874@hornet.din.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hornet.din.cz ([85.13.72.2]:54774 "EHLO hornet.din.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXKGRAS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 12:00:18 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello developers,

I am sorry for what could be a stupid question, but _why_ is the MARK
target allowed only within the `mangle' table? It does _not_ alter the
packet in any way (which I suppose is the reason for all the mangling
targets to be limited to the mangle table, e. g. destroying checksums).

I need some information from tests being performed in the `raw'
table to be reused in other tables, and the mark associated with packet
seems to me to be the only place to note the information. Am I right?

TIA
Milan Krcmar
