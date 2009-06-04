From: Emiliano Romero <emilianoromero@gmail.com>
Subject: Nat+Iptables+Tcp Keepalive Problem
Date: Thu, 04 Jun 2009 10:18:17 -0300
Message-ID: <4A27C999.3000609@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:31605 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZFDNSW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 09:18:22 -0400
Received: by yw-out-2324.google.com with SMTP id 5so443760ywb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Jun 2009 06:18:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi list!, I dont know if I'm doing right posting this problem here.

I'm doing a DNAT to forward connections to port 5555 to another server. 
The connection gets forwarded fine, I can connect, send and recieve data 
over that connection. The problem appear with TCP KeepAlive packets (No 
flags, win=0, len=0). When that packets of a connection that is 
ESTABLISHED (Send and recieve data before) arrives to my iptables 
machine. They arent matched with nat entries of the conection where it 
belongs. So they are marked as INVALID and go to INPUT insted of FORWARD.

TCP Keepalive in the remote side (The one that start the connection) is 
seted at 20 seconds with 4 tries at 10 seconds each one. That's because 
it's over a very bad communication channel.

I add some of my configurations:

Iptables config:
iptables -t raw -A PREROUTING -p tcp --dport 5555 -j TRACE
iptables -t nat -A PREROUTING -p tcp --dport 5555 -j DNAT 
--to-destination 192.168.1.100:5555

Output of Trace: http://pastebin.com/f65e41319

Visual Output of Wireshark of another try: http://tinyurl.com/qlaj9n

# iptables --version
iptables v1.4.1.1

# iptables -S
-P INPUT ACCEPT
-P FORWARD ACCEPT
-P OUTPUT ACCEPT

# iptables -t nat -S
-P PREROUTING ACCEPT
-P POSTROUTING ACCEPT
-P OUTPUT ACCEPT
-A PREROUTING -p tcp -m tcp --dport 5555 -j DNAT --to-destination 
192.168.1.100:5555

# iptables -t raw -S
-P PREROUTING ACCEPT
-P OUTPUT ACCEPT
-A PREROUTING -p tcp -m tcp --dport 5555 -j TRACE

WireShark output of TCP Keepalives:
186449    11772.258110    200.49.201.26=>172.16.102.11    TCP    [TCP 
ZeroWindow] [TCP Keep-Alive] 14032 > 5555 [] Seq=10 Win=0 Len=0
188417    11835.763745    172.16.102.11=>200.49.201.26    TCP    5555 > 
48538 [RST, ACK] Seq=1012825070 Ack=10 Win=0 Len=0

Any idea of what could be happening? Maybe that's not supported. If 
that's the case I'd never develop a kernel module, but I could try.

Regards


