From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: improve error handling: previous patches
Date: Wed, 19 Nov 2008 00:46:13 +0100
Message-ID: <492353C5.2070201@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53274 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752390AbYKRXqY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 18:46:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The previous patches improve a bit the iptables error handling. The last
two patches may seem very stupid but I have seen people stuck on this
errors a lot during some training sessions in the university. If nobody
objects I'll push the to git.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
