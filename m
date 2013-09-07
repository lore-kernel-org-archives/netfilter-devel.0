From: David Gervais <dgervais@gmail.com>
Subject: added new hash:ip,net ipset type
Date: Sat, 7 Sep 2013 12:40:11 -0400
Message-ID: <CADrOd4AhyoQAApNknHHFS+g5TunekdVz0_nR4z2Fh=K2gJNFXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:54028 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab3IGQkM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Sep 2013 12:40:12 -0400
Received: by mail-ve0-f176.google.com with SMTP id jx11so2439345veb.35
        for <netfilter-devel@vger.kernel.org>; Sat, 07 Sep 2013 09:40:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I recently added support for a new hash:ip,net ipset type based
largely off the hash:ip,port,net implementation.

A git repo with the modifications can be accessed here:
https://github.com/dgervais/ipset.git

Looking over the recent mailing list history, it looks like work is
underway on a hash:net,net implementation that would also be
beneficial to the project I am working on. It would serve a very
similar need as the hash:ip,net implementation and may even obviate
its need.

Either way, I figured I would share the contribution in case others
could benefit from its inclusion.

Thanks for all the great work!

-Dave
