From: C.Shelley-02@student.lboro.ac.uk
Subject: IDEA FOR NEW TARGET
Date: Sun, 27 Oct 2002 17:26:49 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1035739609.3dbc21d967912@student-webmail.lboro.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
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

Developers,

I have had an idea for a new target for moifying the TCP flags of a packet.
It may sound a bit odd to do this, but thought it could be used to bypass 
firewalls etc. As you know most firewalls drop incomming packets with just the 
SYN flag set, thus preventing the initiation of incoming connections. 
(This prevents me from SSHing to my box at uni when I am at home.) 
But if the SYN packet was modified before sending, ie to have different flags 
set, it would bypass the firewall. 
(i know nmap can penetrate the firewall using similar method)
The packet must then be de-mangled by the box behind the firewall using the 
same target.

Do you think it will work?
(i am not yet on this list, so please send me an additional reply)

--Craig Shelley   
