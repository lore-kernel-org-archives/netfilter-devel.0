From: Alex Wei <alex.kern.mentor@gmail.com>
Subject: nf_tables_api.c:nf_tables_update cause oops
Date: Fri, 27 Dec 2013 17:26:07 +0800
Message-ID: <CAFyS_9tD-T1ev1sOs7rhjxTA8bm2_3jDZPWVKWt2NfQJDr-ULg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f196.google.com ([209.85.215.196]:47447 "EHLO
	mail-ea0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3L0Jm0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Dec 2013 04:42:26 -0500
Received: by mail-ea0-f196.google.com with SMTP id q10so1875749ead.7
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Dec 2013 01:42:25 -0800 (PST)
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
