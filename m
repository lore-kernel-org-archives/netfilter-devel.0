From: Gregory Vander Schueren <gregory.vanderschueren@tessares.net>
Subject: How to retrieve original source address with FTP/NAT/TPROXY
Date: Tue, 6 Feb 2018 15:40:20 +0100
Message-ID: <1d02f5e0-2a45-f12a-8f81-bc47e84a9455@tessares.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Cc: matthieu.baerts@tessares.net,
        Gregory Detal <gregory.detal@tessares.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37788 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeBFOkX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 09:40:23 -0500
Received: by mail-wm0-f51.google.com with SMTP id v71so4304927wmv.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Feb 2018 06:40:22 -0800 (PST)
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I have the following IPv4 network:

FTPClient <-----------------> Proxy <--------------> FTPServer.
      10.0.0.2          10.0.0.1   1.1.1.1        1.1.1.2

FTPClient connects to FTPServer in PASSIVE mode, meaning the FTPClient
initiates the data connection towards FTPServer. Proxy performs NAT in 
the POSTROUTING chain using the iptables MASQUERADE target. On Proxy, I 
use the iptables TPROXY target to redirect the FTP data connection 
towards a local socket.

Upon accept() on this socket, the address returned by accept() is 
1.1.1.1, not the IP of the Client (10.0.0.2) as I expected. Using 
getpeername() also returns 1.1.1.1. For other TCP connections than FTP 
accept() or getpeername() returns 10.0.0.2.

I noticed this only occurs when using the NF_CONNTRACK_FTP and 
NF_NAT_FTP kernel modules.

Note that I was able to retrieve the FTPClient IP on Proxy from
/proc/net/ip_conntrack. I also made a quick patch to add a 
SO_ORIGINAL_SRC socket option (similar to SO_ORIGINAL_DST) which allows 
to retrieve the FTPClient IP. Since this option does not exist yet, I am 
wondering if this is relevant to add such an option?

Also, this does not occur in IPv6.

Is this behavior normal?
What is the rationale behind this?

Any help in understanding what happens would be much appreciated,
Gregory

-- 

------------------------------
DISCLAIMER.
This email and any files transmitted with it are confidential and intended 
solely for the use of the individual or entity to whom they are addressed. 
If you have received this email in error please notify the system manager. 
This message contains confidential information and is intended only for the 
individual named. If you are not the named addressee you should not 
disseminate, distribute or copy this e-mail. Please notify the sender 
immediately by e-mail if you have received this e-mail by mistake and 
delete this e-mail from your system. If you are not the intended recipient 
you are notified that disclosing, copying, distributing or taking any 
action in reliance on the contents of this information is strictly 
prohibited.
