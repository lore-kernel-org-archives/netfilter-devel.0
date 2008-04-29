From: amna bilal <bilal.amna@yahoo.com>
Subject: Bug finder
Date: Tue, 29 Apr 2008 13:15:19 -0700 (PDT)
Message-ID: <916407.60109.qm@web57406.mail.re1.yahoo.com>
Reply-To: bilal.amna@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n7.bullet.re3.yahoo.com ([68.142.237.92]:28293 "HELO
	n7.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755556AbYD2UPW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Apr 2008 16:15:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The following are my netfilter patches for 2.6.17, which fix a couple of bad bugs:

- The SCTP conntrack loop noticed by Ingo
- The unchecked __copy_from/to in the compat code noticed by Linus
- Two H.323 bugs found by the PROTOS c07-h2250v4 testsuite

I'll push the SCTP patch to -stable as well. There is still at least one open bug in the H.323 helper, but I can't really keep up with the pace new bugs are discovered at currently.

Any help will be appreciated.

Thanks
Have a nice day!


      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ

