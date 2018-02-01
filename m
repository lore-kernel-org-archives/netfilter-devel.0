From: Florian Westphal <fw@strlen.de>
Subject: Re: possible deadlock in xt_find_target
Date: Thu, 1 Feb 2018 19:06:56 +0100
Message-ID: <20180201180656.GB11048@breakpoint.cc>
References: <001a113f890435f93f0563c78742@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+5208e0989d3d8116837d@syzkaller.appspotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49920 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751378AbeBASJv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Feb 2018 13:09:51 -0500
Content-Disposition: inline
In-Reply-To: <001a113f890435f93f0563c78742@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

#syz fix: netfilter: on sockopt() acquire sock lock only in the required scope
