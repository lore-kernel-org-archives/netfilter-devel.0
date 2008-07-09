From: "tung tran" <tunghack@gmail.com>
Subject: Netfilter module help
Date: Wed, 9 Jul 2008 17:58:59 -0500
Message-ID: <13f1ba4c0807091558m5fff70ear7515557278001922@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:25652 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbYGIW7C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:59:02 -0400
Received: by yx-out-2324.google.com with SMTP id 8so935767yxm.1
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Jul 2008 15:58:59 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
I am writing a kernel module that hooks into netfilter.
netfilter_ops.hook              =       main_hook;
netfilter_ops.pf                =       PF_INET;
netfilter_ops.hooknum           =       NF_IP_PRE_ROUTING;
netfilter_ops.priority          =       NF_IP_PRI_FIRST;
nf_register_hook(&netfilter_ops);

In the main_hook function, I needs to put the process to sleep and
will be woken up by another process because the decision to Accept or
Deny a packet depends on a process running in the user space. However,
all sleeping mechanism I tried  cause the kernel hang. I tried msleep,
wait_event_interrupt,wait_event_interrupt_timeout,... (of course I
have a process to wake up the main_hook process). I tested these
sleeping machenism in different modules and they worked fine. My
question is can we make the process sleep in the main_hook function
without causing the kernel hang and how to do it?
Thank you very much.
Tung.
