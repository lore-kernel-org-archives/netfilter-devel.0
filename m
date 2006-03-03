From: suparna misri <suparnamisri@yahoo.com>
Subject: PLZ HELP
Date: Thu, 2 Mar 2006 21:08:20 -0800 (PST)
Message-ID: <20060303050820.31966.qmail@web32807.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

 Hello,
     I am doing a small project in networking in which
 I will compress packets at sender side and receiver
 will decompress the packets.I am using "iptables
 ip_queue module" for capturing and changing the
 contents of packets which I know how to do. My
problem
 is that if packet is lost and does not reach to the
 receiver then it cannot decompress it . How can
 receiver notify sender(eg send nack) that it does not
 have the required packet so that sender can send it
 again. Should I build and send a new packet or can I
 use "iptables ip_queue modules" for the same.
 
 I hope I could explain my point well.
 I will really appreciate any help.
 Thanks. 
 
 Sincerely,
 Suparna.

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
