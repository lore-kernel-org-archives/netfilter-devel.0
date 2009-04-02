From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Buffering and libnetfilter
Date: Thu, 2 Apr 2009 15:12:53 +0200
Message-ID: <17e3a8f80904020612u4ccbff81h5b9a009fe1e81227@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58765 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309AbZDBNM5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 09:12:57 -0400
Received: by fxm2 with SMTP id 2so515410fxm.37
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 06:12:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am currently working a small user space program that queues packets
sent from kernel space and after a while passes them "back" to the
kernel. However, when the bandwidth is high, there seems to be some
buffer-problems. Suddenly my application stops receiving packets from
netlink and no packets get through.

First I thought it might be that I have exceeded the allowed queue
length, but that is not the case. The id of the last received packet
is well below 1024. Does anyone know what might be wrong or have any
tips? Also, is it possible to adjust netfilter's buffersize?

-Kristian
