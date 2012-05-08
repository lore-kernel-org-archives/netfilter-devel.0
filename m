From: Gaurav Sinha <vgsinha@gmail.com>
Subject: iptables ulog-cprange
Date: Tue, 08 May 2012 13:58:44 -0700
Message-ID: <4FA98904.3070008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083Ab2EHU6q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 16:58:46 -0400
Received: by pbbrp8 with SMTP id rp8so8518696pbb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 May 2012 13:58:46 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

I am getting this error which points out the ulog-cprange that I am 
using is incorrect. It
should be a value in between 1-50. The man page says 0 is allowed too, 
i.e. any number of
bytes. But, I cannot configure zero as well.

Is zero no longer supported? Probably the man page is not updated with 
this information.

iptables v1.4.12.2: ULOG: bad value for option "--ulog-cprange", or out of
range (1-50).

Try `iptables -h' or 'iptables --help' for more information.
Error: [iptables -t raw -I MY_PREROUTING_HOOK 1 -i eth0 -j ULOG
--ulog-nlgroup 2 --ulog-cprange 64 --ulog-qthreshold 10] failed - 512

Thanks
Gaurav
