From: Ryan Johnston <ryan@mediapixel.co.nz>
Subject: netlink multi-thread / libmnl / nfq
Date: Wed, 3 Jun 2015 09:17:36 +1200
Message-ID: <CAJ0j+bpNqDJZTcbU-4wHcmNT8=28U3jJ5ftu-OpbpfZJjAjBxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:33490 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbbFBVRg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 17:17:36 -0400
Received: by ykfr66 with SMTP id r66so57797825ykf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Jun 2015 14:17:36 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

When creating a multi-threaded NFQ/Netlink application, should I have
multiple threads with fd sockets connected to the kernel, or do I have
one socket with multiple thread loops to read the socket?

If I am to have many threaded fd sockets connected to kernel's
netlink, is there any performance loss by having too many?
