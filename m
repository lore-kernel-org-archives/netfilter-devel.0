From: Salis Joshi <salis.joshi@gmail.com>
Subject: Linux Module based on netfilter hooks
Date: Tue, 21 Jun 2016 12:20:23 +0200
Message-ID: <CAE34MW1VqoADpT_+JFrOq1+ieXq337ZhboW-4dn=0JyzQ9ezQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33128 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbcFUKUn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jun 2016 06:20:43 -0400
Received: by mail-qk0-f195.google.com with SMTP id a186so2034165qkf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jun 2016 03:20:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I am developing a new linux kernel module based on netfilter hooks. I
am new in the area of linux kernel module development. And, I am
having problems regarding the function definition of hook functions.

I was referring to the code which used netfilter for my module. This
reference code was based on linux kernel 2.X. I am using linux kernel
4.4.X for my development and this same code serves many purpose to me.
However, after I looked into the function definition of hook functions
for linux kernel 4.4.X and tried to change the code accordingly, many
problems are coming up.

I was wondering, I you guys can help me with some samples for using
netfilter hooks at local_out and local_in based on linux kernel 4.4.X.
I was not able to find any samples/examples related to this linux
kernel version on the web.

Thanks in advance.

-- 
Best Regards
Salis Joshi
