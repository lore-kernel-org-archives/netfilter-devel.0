From: Fr3DBr <fr3dbr@gmail.com>
Subject: Sending Data
Date: Sun, 25 Mar 2012 22:40:36 -0300
Message-ID: <CAMpo4z1NOME_kdthqKdO2XT=Xzy9aHRRb3typYH7Wy5rjoK=bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38350 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2CZBkh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:40:37 -0400
Received: by pbcun15 with SMTP id un15so5323780pbc.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Mar 2012 18:40:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

i've hooked : NF_IP_PRE_ROUTING

so i wanted to know, how could i send raw data back to the interface
some data come from ?

would NF_HOOK for NF_IP_POST_ROUTING be appliable in this case ?!

Thanks !
