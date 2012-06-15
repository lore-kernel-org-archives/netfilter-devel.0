From: AFT <aftnix@gmail.com>
Subject: Netfilter Debugging tips
Date: Fri, 15 Jun 2012 20:08:34 +0600
Message-ID: <aa04pt0d.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849Ab2FOOSK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:18:10 -0400
Received: by pbbrp8 with SMTP id rp8so5340716pbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Jun 2012 07:18:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

I have a working kernel dev setup with KGDB/KDB. Now as i'm going to
develop a netfilte module, i need a good strategy to debug netfilter
modules. During configuring the kernel i've bumped into a kernel config
like following :

CONFIG_NETFILTER_DEBUG

But i've found no documentaion describing what actually this
configuration will enable me to do.

So anything regarding this config variable or any other general
debugging strategy will be helpfull.

Cheers.

------
-aft 
