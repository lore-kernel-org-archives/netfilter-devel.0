From: Scott MacKay <scottmackay@yahoo.com>
Subject: QUEUE handling, growing the packet.
Date: Mon, 10 May 2004 11:10:45 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040510181045.82040.qmail@web13905.mail.yahoo.com>
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

Hi, 
  In a userspace app, given packets by QUEUE, I want
to grow the data packet.  The key problem I see is
that the ipq_read() buffer is both the payload and the
ipq_packet_msg structure (I think along with some
potential alignment), making a simple malloc for the
data space hard.  Given that you use ipq_get_packet()
to extract the packet (plus payload offset) from the
buffer, can I just malloc()  a larger data space and
re ipq_get_packet()?  Given:

len = ipq_read(s, buffer, 4096, 0);
m = ipq_get_packet(buffer);
old_len=m->data_len;

If I wanted to have the packet be 'new_len' bytes
instead of 'old_len' would the following work (yes,
minus memory checks and such):

new_buffer_len = len - old_len + new_len;
newBuffer=(char *)malloc(new_buffer_len);
memcpy(newBuffer,buffer,len);
m = ipq_get_packet(newBuffer);

My goal would to be able to use 'm' as if there is no
change, but know that I have the additional space to
alter payload contents.  Thanks for any hints!



	
		
__________________________________
Do you Yahoo!?
Win a $20,000 Career Makeover at Yahoo! HotJobs  
http://hotjobs.sweepstakes.yahoo.com/careermakeover 
