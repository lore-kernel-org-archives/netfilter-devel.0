From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: ipset v5.0-pre10
Date: Wed, 15 Dec 2010 14:28:54 +0000
Message-ID: <4D08D0A6.4020900@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:57679 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab0LOO3C (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 09:29:02 -0500
Received: by eyg5 with SMTP id 5so1204847eyg.2
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2010 06:29:01 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I've just looked at the code and man pages for the above - it makes some 
interesting reading!

I have a question though - Would it be possible for me to specify port 
ranges as well - if not at the members level, then at least from the 
command line?

For example, with the current setup if I want to include 'low' ports in 
a set, then I have to run a separate script with a 'count' value from 1 
to 1024 and execute 1024 different 'ipset -A' statements to include that 
particular port into the set. The situation is much worse if I am 
dealing with high-ports - for obvious reasons.

Would it be possible to be able to specify port ranges (say, '1-1024') 
in a similar fashion as it is currently done with ip address ranges?


