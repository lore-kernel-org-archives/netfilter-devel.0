From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: ulogd2 commit
Date: Fri, 17 Apr 2009 12:52:29 +0200
Message-ID: <49E85F6D.9030008@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, Pierre Chifflier <chifflier@inl.fr>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43056 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754607AbZDQKwi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 06:52:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric, Pierre,

Please, could you justify the need for commit
0ff525cb0506b2c043bc9df6d7e7b486c865bc38?

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=ulogd2.git;a=commit;h=0ff525cb0506b2c043bc9df6d7e7b486c865bc38

I don't think that it's a good idea to support external compilation of
ulogd2 modules. We should promote people to push forward things to mainline.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
