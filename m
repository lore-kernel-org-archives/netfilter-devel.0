From: "Duncan Godfrey" <d.j.godfrey@reading.ac.uk>
Subject: libipq Packet queuing Question
Date: Thu, 21 Jul 2005 19:49:47 +0100
Message-ID: <E1Dvg7E-0000uW-00@vimh1.rdg.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

 

Would anyone be able to help me with my libipq development, I'm really
stuck.

 

I'm trying to create a QoS app for Linux and I'm using a number of simple
FIFO queues (just using arrays) to queue the packets before they are
dispatched in the required order.

 

The problem I am having is, apart from my basic knowledge of c, is that you
cant queue a pointer. So when you receive the pointer from the method
ipq_packet_msg_t *m, this cant be queued (e.g. if you queue packets 1,2,3
they will be dispatched 1,1,1).

 

I have tried dereferencing the *m pointer but this doesn't give you a copy
of the packet it actually seems to give you a blank packet.

 

Has anyone designed any packet queuing applications or know of any examples
which could point me in the right direction.

 

Thank you in advance for your help,

 

Duncan Godfrey
