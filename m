From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC] removing debian/ directories in the git tree
Date: Wed, 09 Jul 2008 16:24:29 +0200
Message-ID: <4874CA1D.7090500@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Max Kellermann <max@duempel.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36343 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753182AbYGIOYf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:24:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I'm planning to remove the debian/ directories under the git trees
(tools and libraries). The debian project is supposed to supply these
packages. Moreover, as for now, they are pretty outdated. Are you OK
with this?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
