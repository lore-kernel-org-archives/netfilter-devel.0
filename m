From: Chee Yong TAN <chee_yong_tan@hotmail.com>
Subject: Sending back out A TCP Packet from netfilter
Date: Mon, 23 Feb 2004 11:56:25 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403979E9.8070300@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I need to do some mangling of a TCP packet at netfilter level and send 
the packet out back to the sending host.Upon receiving the packet, my 
module will check if the packet need to be send back to the sending host 
  after mangling.I tried using ip_send() to send back the packet but it 
don't seem to work but when i do a tcpdump capture i manage to capture 
the packet. I return a verdict of NF_STOLEN for the received packet. I 
did invert the ip address, ports and the hardware address. I also 
updated the sequence numbers in the header.

What is the proper procedure in getting the packet send out back to the 
network ?

I need it to support both 2.2 and 2.4 kernels

Thanks in advance

Regards,
Chee Yong
