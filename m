From: Richard <tuxbox.guru@gmail.com>
Subject: Netfilter_Bridge parent bridge name in hook
Date: Sun, 22 May 2016 20:05:31 +0100
Message-ID: <CAKQROYVMwycJ-EyWNkHMKpk66a68rTdiCV-tCfyNqW8nspunVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35533 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbcEVTFd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 May 2016 15:05:33 -0400
Received: by mail-lf0-f67.google.com with SMTP id p10so5211898lfb.2
        for <netfilter-devel@vger.kernel.org>; Sun, 22 May 2016 12:05:32 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I have a netfilter_bridge hook kernel module working very well, but it
acts on all bridge interfaces.  Not for a lack of trying to find a
method to find which will show me the name of the Bridge interface the
ingress/egress net_devices are a member of.

Below is the hook (boiler plate prototype) - in->name = eth0, which is
what I need... but I also need to know what bridge eth0 is enslaved
in.

unsigned int nf_icmp_forward_hook(unsigned int hooknum,
                                  struct sk_buff* skb,
                                  const struct net_device* in,
                                  const struct net_device* out,
                                  int (*okfn)(struct sk_buff*));


How can I get the Bridge name that the IN devices is a member of.

Any pointers would be greatly appreciated.


Regards,
Richard
