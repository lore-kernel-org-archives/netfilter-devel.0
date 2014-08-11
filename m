From: Yanchuan Nian <ycnian@gmail.com>
Subject: Bug: nft cannot identify elements in set correctly
Date: Mon, 11 Aug 2014 17:18:31 +0800
Message-ID: <1407748711-21183-1-git-send-email-ycnian@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Yanchuan Nian <ycnian@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35667 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaHKJPY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Aug 2014 05:15:24 -0400
Received: by mail-pa0-f44.google.com with SMTP id eu11so10855692pac.3
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Aug 2014 02:15:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

nft cannot identify elements in set correctly, look at the result of
following commands.

[root@localhost ~]# nft add set ip filter servicelist {type inet_service \;}
[root@localhost ~]# nft add element ip filter servicelist {ftp,ssh}
<cmdline>:1:35-37: Error: syntax error, unexpected string, expecting '{'
add element ip filter servicelist ftp ssh
                                  ^^^
[root@localhost ~]# nft add element ip filter servicelist {ftp, ssh}

There must be a space between ftp and ssh, otherwise bison ignores "{".
But it's strange that this bug doesn't exist in interactive mode.

[root@localhost nftables]# nft -i
nft> delete element ip filter servicelist {ftp,ssh}
nft> add element ip filter servicelist {ftp,ssh}
nft> 
nft> list table ip filter
table ip filter {
	set servicelist { 
		type inet_service
		elements = { ssh, ftp}
	}
}
nft> 

What's the difference between shell mode and interactive mode? I thought
they are the same except you don't need to type "nft" at the beginning
of each command in interactive mode.
