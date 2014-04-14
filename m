From: Ana Rey <anarey@gmail.com>
Subject: cannot stat 'doc/nftables.8': No such file or directory
Date: Mon, 14 Apr 2014 11:37:36 +0200
Message-ID: <CAD7o0sja_p2BhAuDMBEqR7Y6oprGs+nViDTC66Xr9-RU0H54LQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47488 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbaDNJh5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:37:57 -0400
Received: by mail-ve0-f179.google.com with SMTP id db12so7079374veb.38
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Apr 2014 02:37:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

With the last changes in nftable (last commit 'doc: change
documentation license to CC BY-SA 4.0')

$ sudo make install
-e   SUBDIR src/
-e   INSTALL nft
-e   SUBDIR files/
-e   INSTALL files
-e   SUBDIR doc/
-e   MAN doc/nftables.8
-e   INSTALL doc
/usr/bin/install: cannot stat 'doc/nftables.8': No such file or directory
make[1]: *** [install] Error 1
make: *** [doc] Error 2

I have docbook in my system, and I try to install it before a 'make
clean'  and './autogen.sh'

-- 
Ana Rey (@anaRB)
http://about.me/anarey
