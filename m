From: Andrew Watts <akwatts@ymail.com>
Subject: More sophisticated NFQUEUE analysis
Date: Sun, 21 Mar 2010 02:14:16 -0700 (PDT)
Message-ID: <886428.5742.qm@web111011.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web111011.mail.gq1.yahoo.com ([67.195.15.188]:35842 "HELO
	web111011.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751410Ab0CUJU6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Mar 2010 05:20:58 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am interested in doing userland analysis on -j NFQUEUE packets but require more information than it seems libnetfilter_queue provides. Specifically, does the current implementation export the packet's owner socket structure (skbuff->sk) to userland? I would like to get inode info, in particular.

If not, can anyone suggest a simple way to achieve this? Many thanks.

~Andy


      
