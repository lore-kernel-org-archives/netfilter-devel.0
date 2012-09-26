From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: searching tuples in conntrack
Date: Wed, 26 Sep 2012 12:29:17 -0500
Message-ID: <CA+Z0r8MVyzWP_uM+Ryge5YY8Dr9XO+Uh1x0g7Zc8FBp16mMAGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:53466 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2IZR3s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:29:48 -0400
Received: by vbbff1 with SMTP id ff1so921730vbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Sep 2012 10:29:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have been reading some kernel code trying to find a function that
searches the conntrack hash table for a transport address and returns
the given tuple. Is there any way to do this? I found a function in
the nat code called find_appropriate_src but i think it only works for
the nat table...

Regards
