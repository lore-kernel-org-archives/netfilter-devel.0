From: Scott MacKay <scottmackay@yahoo.com>
Subject: Duplicating packets, ether headers?
Date: Tue, 20 Jan 2004 08:11:06 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040120161106.19440.qmail@web13909.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Poking thru the code for ip_queue.c (code for QUEUE
usespace targets), I found that the source ethernet
address is stored in the hw_addr field (from
eth_header_parse).  This means the source ethernet
address should be accessible from userspace code as it
gets ipq_packet_msg packets.  I was wondering, though,
if there was a reason why the ethernet destination
address is not passed up.  
In userspace, I would like to duplicate a packet being
intercepted by the QUEUE target (namely, UDP packets).
 The only way I know of is to use libpcap and build
the entire message.  Is there a way to get the
destination ethernet address, or will I need to code
in a new field for the ipq_packet_msg?

__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
