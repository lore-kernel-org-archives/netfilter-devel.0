From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: QUEUE, large udp message failure
Date: Thu, 6 May 2004 14:53:31 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040506215331.31054.qmail@web13906.mail.yahoo.com>
References: <200405061528.16034.rmiller@duskglow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200405061528.16034.rmiller@duskglow.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I actually have tried it with 65535 (and larger, since
I think the buffer space is also used for the packet
msg), same problem. I am quite positive the 24K
message I make is the largest being processed, so the
64000 buffer should be large enough).   One thought I
have not looked at yet; I use a static buffer to read
in ipq_read().  I then allocate a buffer large enough
to hold the returned data, memcpy the buffer over, and
then call ipq_msg_type(), ipt_get_packet, etc.  Could
this be causing any problems? 


--- Russell Miller <rmiller@duskglow.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On Thursday 06 May 2004 14:45, Scott MacKay wrote:
> 
> > Where PACKET_SIZE_MAX is 64000.  I have a normal
> > ipq_read() loop using the readBuffer and it
> normally
> > works fine, allowing me to do my stuff with the
> > packet.
> > The problem comes in when I get a large message
> > (tested was 24000 bytes).  ipq_read fails.  I
> added
> > some debug and it seems to be in
> > ipq_netlink_recvfrom() where the recvfrom() fails
> with
> > errno=105.  Is there some artifical cap on the
> size of
> > a message which can be passed to the QUEUE target?
> >
> Don't know if this helps, but:
> 
> The payload size can be as high as 65536 bytes.  If
> your buffer is not large 
> enough to receive the payload, ipq_read will return
> with ENOBUFS, which means 
> your buffer is not large enough.  I bet if you set
> PACKET_SIZE_MAX to 65536, 
> that problem goes away.



	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
