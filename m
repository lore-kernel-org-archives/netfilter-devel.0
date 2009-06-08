From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [resend2] Socket match with transparent option, take 2
Date: Mon,  8 Jun 2009 14:30:22 +0200
Message-ID: <1244464224-30692-1-git-send-email-panther@balabit.hu>
References: <4A27CD5A.6040303@trash.net>
Cc: kaber@trash.net, Laszlo Attila Toth <panther@balabit.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:41206 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752638AbZFHMa1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2009 08:30:27 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 49F1A13A29E
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Jun 2009 14:30:27 +0200 (CEST)
In-Reply-To: <4A27CD5A.6040303@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Patrick,

I updated the code as you and Jan suggested: added flags,
more readable and documented conditions within xt_socket.c

--
Attila
