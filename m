From: <eem1wc@eim.surrey.ac.uk>
Subject: [libipq] Buffer size
Date: Fri, 14 Jun 2002 17:21:25 +0100 (BST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1147.131.227.137.82.1024071685.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi... 

   I am currently using iptables (1.2.5) and libipq to develop a user program 
(using the QUEUE target) that would introduce an extra delay for packets going 
through a bridge (bridge-utils-0.9.5). While using ping, the program works 
fine. But when i test it with Microsoft Netmeeting to transmit voice (no video 
yet), i quickly receive a message as below:-

read(): Failed to received netlink message: No buffer space available

my program ended with the message above.

My questions:
[1] how big is this buffer?
[2] how can i go about to solve this problem? I typically need to introduce a 
round-trip delay of 500ms (i.e. 250ms from src to dest through the bridge)?
[3] can i do anything to enlarge this buffer?

Thank you in advance. 
