From: JieYue Ma <xiaoma80.dev@gmail.com>
Subject: reason that iptables mac module only has mac-source option
Date: Thu, 24 May 2012 12:47:44 +0800
Message-ID: <CAJ6iH_i17NBvEA_2NgmvErsu310-_reZxMjSpnn61rMPF60siA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41072 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2EXErp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 May 2012 00:47:45 -0400
Received: by dady13 with SMTP id y13so10746565dad.19
        for <netfilter-devel@vger.kernel.org>; Wed, 23 May 2012 21:47:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi guys,

I am working on the mac module, and I added some arp related options
in it. I noticed that this module originally has only --mac-source
options in it. At first I think maybe author didn't want touch any
output packet. But now I doubt that maybe iptables hook point doesn't
support to do so. That is why I came here asking you guys for help. I
think in iptables OUTPUT hook point, it has not yet generate any 2nd
level information in the skb buffer, hasn't it? That is why mac module
can only touch incoming packet because only the incoming packet takes
the mac information in iptables

anybody can answer me? thanks a lot

BRs
jerry ma
