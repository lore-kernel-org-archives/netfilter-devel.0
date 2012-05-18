From: JieYue Ma <xiaoma80.dev@gmail.com>
Subject: Questions about ebtables QUEUE/NFQUEUE target implementation
Date: Fri, 18 May 2012 14:13:14 +0800
Message-ID: <CAJ6iH_gdycGwp5B2mprYdtwcFh4S0mvqnOTf5wEWMoEWocgUvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50531 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755413Ab2ERGNO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 May 2012 02:13:14 -0400
Received: by pbbrp8 with SMTP id rp8so3517126pbb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 17 May 2012 23:13:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hello, everyone,

We are carrying out a project related with ebtables/arptables. We plan
to add logic in user space to deal with arp packets. But I found out
in ebtables homepage that the QUEUE/NFQUEUE target has not been
supported yet, while it is supported already in iptables. So does
community has any plan to support QUEUE/NFQUEUE target in ebtables? If
not, maybe we can contribute to do so.

As for arptables, I am not sure if it is supported already. I wrote
small programs using libipq as well as libnetfilter_queue, but both do
not work anyway. It does work together with iptables.

Thanks
Jerry Ma
