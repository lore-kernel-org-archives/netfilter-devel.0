From: Maninder Singh <maninder.tiet@gmail.com>
Subject: Required : Documentation of extension header related functions in
 Linux Kernel
Date: Wed, 3 Sep 2014 22:47:56 +0530
Message-ID: <CAHzLHWptHjkckd7COi+=y7iBvAdFKkRzNTmZWNiZTnxvZJk9Nw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:61362 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670AbaICRR6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Sep 2014 13:17:58 -0400
Received: by mail-la0-f54.google.com with SMTP id b17so10273899lan.13
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Sep 2014 10:17:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi developers,

I need some documentation around the functions that can help parse the
extension headers in kernel. I need this for some research work but
could not find a consolidated text which contains information about
such functions. Basically, I want to develop a hook function which
will be capable of reading the options present in HBH header of
packets being forwarded through the router and optionally change
option data (value) according to my logic before forwarding.

Any pointers will be appreciated.

Thanks
Maninder Singh
