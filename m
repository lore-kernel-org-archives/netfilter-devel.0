From: cranium2003 <cranium2003@yahoo.com>
Subject: modifying tcp/ip stack
Date: Fri, 20 Aug 2004 22:47:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040821054732.28472.qmail@web41408.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernerl mail <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268851AbUHUFrf@vger.kernel.org>
To: netfilter <netfilter-devel@lists.netfilter.org>
List-Id: netfilter-devel.vger.kernel.org

Hello,
        I want to modify existing protocol stack as
given below.
        What exactly i want to do is that i want to
add a new protocol headerin between IP and ETHERNET
header.
        I want to implement packet structure as
(Ethernet header +MY header + IP header +TCP header +
PAYLOAD) that mean when packet comes from NIC it
should first remove MY header in my routine then IP
header in ip_input.c file.
        Also at transmitting end packet at IP layer
with (IP header + TCP header +PAYLOAD)structure passed
to ip_output.c then given to my routine for adding a
new protocol header on that packetand then to Ethernet
layer.
        I want your help to know what changes i
require to do in kernel 2.4.24 to achieve this?
         Please kindly reply me.
Thaking you.

Regards,
Parag.


		
__________________________________
Do you Yahoo!?
Yahoo! Mail is new and improved - Check it out!
http://promotions.yahoo.com/new_mail
