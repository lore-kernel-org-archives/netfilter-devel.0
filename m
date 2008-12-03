From: ivan <lagigliaivan@gmail.com>
Subject: L2 NAT
Date: Wed, 3 Dec 2008 15:22:27 -0200
Message-ID: <f4d9d6df0812030922y34efdaddu16c808ee637beb4b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:38421 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLCRW3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2008 12:22:29 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1899082nfc.21
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2008 09:22:27 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

After having a lot of help of Grant Taylor in order to analyze if I
was able to achieve my idea using the available iptables features, and
getting as result the fact that I had to develop my own kernel module.
I'm writing to this list because my question is related to the linux
kernel programing.

I would like to pass parameters to the kernel module in run time from
user space. These parameters could be IP address and MAC. Somebody
know how I can do this??

I was thinking about passing this parameters thorough a sysctl syscall
or using /proc filesystem, but I beleave that this is not the correct
way.

Also I was taking a look to iptables source code and analyzing the
source code of iptables and libiptc lib, but I could not find any clue
how to these ones change the kernel parameters.

Could you pleas help me???

thanks!
