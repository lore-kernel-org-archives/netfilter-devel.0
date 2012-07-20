From: John Tran <njhtran@gmail.com>
Subject: Problem with iptables accounting in Ubuntu Precise 12.04 LTS
Date: Fri, 20 Jul 2012 10:44:43 -0700
Message-ID: <CAHHzA4XF-f9LMTAmFpC65u0ikFd-9Sd76A0q+Qr5E9Xbr5eVEQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43492 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab2GTRop (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:44:45 -0400
Received: by lbbgm6 with SMTP id gm6so5328736lbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jul 2012 10:44:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm trying to get iptables accounting working on Ubuntu 12.04 LTS
amd64 yet not having much luck.  Here is what I'm getting and I hope
someone can provide some insight to my problems:

root@ubuntu-mbp:~# dpkg -l|grep xtables
ii  xtables-addons-common                           1.40-1
                      Extensions targets and matches for iptables
[tools, libs]
ii  xtables-addons-dkms                             1.40-1
                      Extensions targets and matches for iptables
ii  xtables-addons-source                           1.40-1
                      Extensions targets and matches for iptables
[modules sources]
root@ubuntu-mbp:~# iptaccount -a

libxt_ACCOUNT_cl userspace accounting tool v1.3

get_table_names failed: Can't get table names from kernel. Out of
memory, MINBUFISZE too small?
root@ubuntu-mbp:~# iptaccount -u

libxt_ACCOUNT_cl userspace accounting tool v1.3

get_handle_usage failed: Can't get handle usage information from kernel
