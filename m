From: jordi guri <jordi@northome.ca>
Subject: Filtering invalid MAC addresses
Date: Sun, 27 Nov 2016 18:09:11 -0800
Message-ID: <7e23d525adcd53f91eb6bf6db65a7e91@northome.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:35593 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753290AbcK1CQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 21:16:12 -0500
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 6FCF1E143
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Nov 2016 21:09:12 -0500 (EST)
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (easymail-mailout.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id y0pHUC5d-TAf for <netfilter-devel@vger.kernel.org>;
        Sun, 27 Nov 2016 21:09:11 -0500 (EST)
Received: from webmail.easymail.ca (messages.easymail.ca [64.68.200.64])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout.easymail.ca (Postfix) with ESMTPSA id 775DEE136
        for <netfilter-devel@vger.kernel.org>; Sun, 27 Nov 2016 21:09:11 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I was wondering if the newer nftables is able to deal with invalid MAC 
addresses.  iptables I don't think can deal with these.  For example I 
have the following showing up in my log (from some anonymous proxy port 
scanner):
+++++
Nov 27 17:27:40 northome kernel: ** iptables-DROP ** IN=eth0 OUT= 
MAC=f2:3c:91:9b:81:db:84:78:ac:0d:79:c1:08:00 SRC=183.
60.48.25 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x20 TTL=51 ID=0 DF 
PROTO=TCP SPT=12208 DPT=5902 WINDOW=8192 RES=0x00 SYN
  URGP=0

Nov 27 17:31:50 northome kernel: ** iptables-DROP ** IN=eth0 OUT= 
MAC=f2:3c:91:9b:81:db:84:78:ac:0d:a6:41:08:00 SRC=175.
194.186.44 DST=23.92.27.236 LEN=40 TOS=0x00 PREC=0x00 TTL=52 ID=39168 
PROTO=TCP SPT=24565 DPT=23 WINDOW=19941 RES=0x00 S
+++++

There are many such entries as the above (all day, every minute) for 
various destination ports on my server, and (in this case) with the same 
2 invalid MAC addresses.

What is interesting about this is that the first part of both of the 
above MAC addresses in my iptables log are; "f2:3c:91:9b:81:db".  This 
happens to be the same MAC address as that of my server's eth0 
interface.  Therefore I cannot block these scan attempts via the MAC 
address alone (even if I could in part).

So my question;  Does/is nftables/iptables going to offer some sort of 
solution to the above invalid MAC address problem, as iptables does 
currently for invalid packets and IP addresses?

Thank-you for your time and your very fine work on this fantastic 
firewall product.


Thanks and regards,

Jordi
