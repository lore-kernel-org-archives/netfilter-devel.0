From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: iptables-nftables: Invalid argument
Date: Thu, 30 May 2013 22:39:39 +0200
Message-ID: <CAFpD06Qpkm2sXQc0UAN1JfBeHX0sP9TH9mgca4q_d2y5pSQSxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:59617 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757722Ab3E3Ujl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 May 2013 16:39:41 -0400
Received: by mail-ve0-f179.google.com with SMTP id d10so558563vea.38
        for <netfilter-devel@vger.kernel.org>; Thu, 30 May 2013 13:39:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I've compiled iptables-nftables on debian 7 vm, with kernel 3.2.0
If i run the command xtables -L i got these errors:

mnl-talk:nft_table_init_one: Invalid argument
mnl_talk:nft_chain_builtin_add: Invalid argument
mnl_talk:nft_chain_builtin_add: Invalid argument
mnl_talk:nft_chain_builtin_add: Invalid argument
mnl_talk:nft_chain_list_get: Invalid argument

Instead, if i run the command iptables -L works fine.
What's wrong?

Thanks
