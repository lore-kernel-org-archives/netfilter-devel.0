From: Alex Wei <alex.kern.mentor@gmail.com>
Subject: nf_tables_api.c:nf_tables_update cause oops
Date: Fri, 27 Dec 2013 17:33:08 +0800
Message-ID: <CAFyS_9uJDMEvOnWzmif7ZFmDFCUTDeixPZEr2Co2F_GUb24gNA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f196.google.com ([209.85.215.196]:59487 "EHLO
	mail-ea0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab3L0JdJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:33:09 -0500
Received: by mail-ea0-f196.google.com with SMTP id q10so1872653ead.3
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Dec 2013 01:33:08 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
When I do these operations:

#nft add table table1
#nft add chain table1 chain1
#nft-table-upd ip table1 dormant

there is a oops. the nft-table-upd program is from libnftables/examples.

When we active or disactive a table, I think we should judge whether
the chain of the table is a base-chain or not first, right?

Best wishes.

Alex Wei
