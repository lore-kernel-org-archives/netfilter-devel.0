From: Thomas Jacob <jacob@internet24.de>
Subject: ip6tables doesn't support --goto option
Date: Fri, 20 Jun 2008 18:45:07 +0200
Message-ID: <1213980307.5485.5.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout01.ims-firmen.de ([213.174.32.96]:35467 "EHLO
	mailout01.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbYFTQpJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2008 12:45:09 -0400
Received: from mailin02.ims-firmen.de ([192.168.1.111])
	by mailout01.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1K9jjX-0001Ci-LV
	for netfilter-devel@vger.kernel.org; Fri, 20 Jun 2008 18:45:07 +0200
Received: from [213.174.32.254] (helo=[192.168.0.170])
	by mailin02.ims-firmen.de with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69)
	(envelope-from <jacob@internet24.de>)
	id 1K9jjX-0001Xy-JE
	for netfilter-devel@vger.kernel.org; Fri, 20 Jun 2008 18:45:07 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello list,

The ip6tables frontend in 1.4.1.1 doesn't seem to support the --goto
option but the code for handling it seems to be in the kernel:

ip6_tables.c/ip6t_do_table
  if (table_base + v != (void *)e + e->next_offset
     && !(e->ipv6.flags & IP6T_F_GOTO)) {
       .....

Is there some sort of technical/political reason for this, or has the
feature simply not been implemented yet (and hence a patch would
probably be welcome)?

    Regards,
        Thomas

