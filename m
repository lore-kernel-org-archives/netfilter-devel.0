From: Kfir Lavi <lavi.kfir@gmail.com>
Subject: Moving modified packets between processes
Date: Sun, 24 Oct 2010 10:54:26 +0200
Message-ID: <AANLkTincYmY4rALnsTTy=K32e7s1crw1nc=gBDHyjj58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64838 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932170Ab0JXIy1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 24 Oct 2010 04:54:27 -0400
Received: by yxn35 with SMTP id 35so1518977yxn.19
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Oct 2010 01:54:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
My task is this:
I want to receive packets arrive to the computer, inspect them (user
mode or in the future in kernel mode), add my own header and hand them
to another process.
I will need to move Ethernet, ARP and IP packets.
What are my options regarding moving the packet modified with new
custom header from one process to another process?
I thought about using netlink sockets. Is it a good choice?

Please feel free to ask any question to clarify my needs.

Regards,
Kfir
