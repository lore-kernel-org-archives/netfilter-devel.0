From: "Balaji Venkatamohan" <bvenkat@ncsu.edu>
Subject: code to display contents for iptables -L not getting invoked | Its
     a test module
Date: Thu, 11 Feb 2010 15:15:07 -0500 (EST)
Message-ID: <62174.152.14.247.142.1265919307.squirrel@webmail.ncsu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from uni11mr.unity.ncsu.edu ([152.1.224.170]:56031 "EHLO
	uni11mr.unity.ncsu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab0BKU1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:27:44 -0500
Received: from uni20wi.unity.ncsu.edu (uni20wi.unity.ncsu.edu [152.1.227.220])
	by uni11mr.unity.ncsu.edu (8.13.7/8.13.8/Nv5.2008.0610.1) with ESMTP id o1BKF7wK029763
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 15:15:08 -0500 (EST)
Received: from uni20wi.unity.ncsu.edu (localhost.localdomain [127.0.0.1])
	by uni20wi.unity.ncsu.edu (8.13.8/8.13.8) with ESMTP id o1BKF7Nd015671
	for <netfilter-devel@vger.kernel.org>; Thu, 11 Feb 2010 15:15:07 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

I developed a match extension and successfully compiled the code into the
extensions directory. I was also able to insert the desired rule and got
the expected performance/output. Everything seems to work fine except that
when I issue iptables -L, it shows under the desired chain that a rule is
present but it doesn't print the contents under the function _mt_print()
function of libxt_*.c file. I am getting the message that 'unknown match
<matchname>'.

Can anyone tell me where I am going wrong?

Thanks and Regards,
Balaji Venkatamohan
