From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Packet Fragementation
Date: Wed, 31 Mar 2004 01:47:38 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403310138340.11956-100000@filer.marasystems.com>
References: <20040330200603.52210.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040330200603.52210.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 30 Mar 2004, Scott MacKay wrote:

> Is the defragmented packet the thing passed up to the
> userspace application?

Yes.

> If so, where in the whole netfilter process is the
> packet re-fragmented? 

Just before it is sent out on the wire. Done by a conntrack hook running
very last at NF_IP_POST_ROUTING (search for ip_refrag).

> Oh, also, if a defragmented packet is passed up, then
> I could see the buffer needs to be fairly large
> (potentially).

Yes, or to be exact up to the maximum size of an IP packet (65535 octets).

> Is there a way to tell how big an
> incoming message awaiting delivery via ipq_read() is? 

libipq does not support this, but it should be possible to peek the size 
with a recvfrom using MSG_PEEK | MSG_TRUNC.

> Is there a way to keep conntrack from passing up a
> de-fragmented packet (so still have conntrack make
> it's session info, but not pass up defragmented data)?

Not yet. In the way things are designed the original fragments is 
completely lost. This is considered a design bug in how conntrack deals 
with fragmented packets bug unfortunately is how things work.

Regards
Henrik
