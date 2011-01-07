From: doug arro <doug_arro@yahoo.com>
Subject: Why and when to use skb_make_writable()?
Date: Fri, 7 Jan 2011 15:11:36 -0800 (PST)
Message-ID: <969249.6164.qm@web111109.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:28887 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751538Ab1AGXLi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 18:11:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

What is the recommended practice for using skb_make_writable()?  I am experimenting with netfilter modules to manipulate IP headers in the mangle table.  Most of the target modules call skb_make_writable() right at the start of the target function but some don't.  What is the conventional wisdom?

Thanks,
doug



      
