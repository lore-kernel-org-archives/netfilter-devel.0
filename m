From: Piotr Duszynski <regis44@gmail.com>
Subject: Conntrack modification
Date: Sun, 09 Nov 2008 14:55:35 +0100
Message-ID: <4916EBD7.2090006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:26012 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795AbYKINzT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 08:55:19 -0500
Received: by fk-out-0910.google.com with SMTP id 18so2635664fkq.5
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2008 05:55:17 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I am working on a project, that needs source MAC information for each
active connection tracked by conntrack. In the beginning I was thinking
 about using the nf_conntrack_tuple.src for this purpose, but then I saw
that the hash function is taking into account this struct as well. I
guess that if I modified it, packets wouldn't be properly identified
anymore as part of existing connection. After diving again into the
source code I have come across nf_conntrack_extend , which seems to a
good place to put the MAC related information.

I am really not sure which path should I take. In the simplest case I
could just add __u32 src_mac to the nf_conntrack_tuple, but this doesn't
seem to be a very elegant solution .

Best regards
Piotrek

