From: Scott MacKay <scottmackay@yahoo.com>
Subject: QUEUE, large udp message failure
Date: Thu, 6 May 2004 12:45:25 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040506194525.38183.qmail@web13907.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello,

   I have a custom QUEUE target, loaded in
POSTROUTING, intended to catch all outgoing packets. 
I have a large buffer allocated (64000 bytes) and
start up the configuration with:
static unsigned char readBuffer[PACKET_SIZE_MAX];

    s = ipq_create_handle(0, PF_INET);
    status = ipq_set_mode(s, IPQ_COPY_PACKET,
PACKET_SIZE_MAX);

Where PACKET_SIZE_MAX is 64000.  I have a normal
ipq_read() loop using the readBuffer and it normally
works fine, allowing me to do my stuff with the
packet.  
The problem comes in when I get a large message
(tested was 24000 bytes).  ipq_read fails.  I added
some debug and it seems to be in
ipq_netlink_recvfrom() where the recvfrom() fails with
errno=105.  Is there some artifical cap on the size of
a message which can be passed to the QUEUE target?

-Scott






	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
