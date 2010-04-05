From: Andrew Watts <akwatts@ymail.com>
Subject: Accessing sk_buf
Date: Mon, 5 Apr 2010 03:10:40 -0700 (PDT)
Message-ID: <174890.36512.qm@web111003.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web111003.mail.gq1.yahoo.com ([67.195.15.140]:29607 "HELO
	web111003.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751291Ab0DEKKl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Apr 2010 06:10:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear list:

I am writing a "bump" message for a previous post of mine. I would like
suggestions or advice on how to go about accessing packet skbuf->sk
fields (inodes, for example), in userspace via NFQUEUE. My read is
that this is currently not possible as these are not exported.

Has anyone played with patches that achieve this? Any suggestions on
where to look?

Also, if this is the wrong place to ask this, would one of you kindly
suggest a more appropriate place?  

Many thanks.

~Andy


      
