From: Scott MacKay <scottmackay@yahoo.com>
Subject: skbuff replication [long]
Date: Fri, 18 Feb 2005 06:59:21 -0800 (PST)
Message-ID: <20050218145921.61380.qmail@web30206.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi all,
   I am looking to work up a patch for packet mangling
to revert the contents of a sk_buff.  My thought was
that whenever a packet's contents could be altered, it
would save a copy of the unaltered packet in case the
packet needed to get reverted.  The only time I think
this is needed is for TCP packets to handle
retransmission due to ackowledgement timeouts.

  What I have seen (2.4.22) is that a retransmitted
packet will go back thru the netfilter cycle, so we
will re-receive the altered contents from any hooks. 
I know this is a problem with ip_queue (when altering
data contents) and not sure but would think this is
also an issue with other content altering bits, like
NAT mangling for FTP and the like.  I think *some* of
the header info is OK, since it seems to rebuild the
headers.  I do also have a problem with I shrink the
packet though as it seems to re-use the original
packet length somehow, causing garbage to be at the
end of the packet.
My thought to remove all that worry was to replicate
the contents.  I am not too worried about the entire
skbuff structure, mainly the data contents where the
packet was being built.  I was looking for any helper
info on how best to proceed.  I have some ideas, but
was hoping for insight into how decent my approach
would be.

The Plan
I need to store a general data buffer in the sk_buff
to keep a copy of the unaltered data segment.  I would
need to add a few fields to the sk_buff to handle
this.  I would add 3 fields to the sk_buff (probably
in a small struct).  First is a data pointer (data). 
This would be an allocated buffer (NULL if not
currently allocated) that would hold the contents of
the copied data.  Next would be a current size
(data_len),  This would show, for an active sk_buff,
how large the active copied data is.  The last would
be a max size (realsize), which is the actual
allocated size.  I figure you would allocate the
needed space and not actually free it;  if the next
user of the buffer was smaller you use the buffer,
only freeing if you need more space.

When a sk_buff is initialized, it will need to clear
out all 3 fields.  This will help insure no garbage in
the data pointer.  Not sure if the normal sk_buff
initialize 0s or not though.

When a sk_buff is assigned, it will need to 0 out the
active size (but keep any data pointer and allocated
size)

The copy would only be needed in ip_queue when you are
informed the data has changed and if the data was TCP.
 Sadly, ipq_packet_msg has no flag to indicate the
data has changed (and even worse, this means you
always do a memcpy).  I may rely on a memcmp (plus the
more obvious  different len) plus a interrogation of
the header to determine if I need to copy.  The
ip_queue would allocate memory if needed and copy the
contents before the memcpy back from the user supplied
buffer.

The trick will be when to copy back the original data.
It likely will only be in a tcp retransmit, the exact
spot(s) I will need to track down.  In there, we need
to check for an active size.  If it exists, we will
want to copy out the data to the sk_buff data area.  I
am guessing we should do the same checks the
ipq_mangle_ipv4 does and do a skb_trim or
skb_copy_expand prior to insure it will have the same
space.  I do see the skb_copy_expand gets a new
sk_buff pointer so growing could be tricky.  Not sure
how best to handle that, but I am guessing it depends
where exactly I have the reverting code.
I don't think any special locking will be needed, as
the bit doing the alteration should have control over
the sk_buff already.
Now, if this all looks good, this could actually be
expanded to any other content changers.  The caveat to
add would be that you should only copy the data if the
active size==0.  If it is not, someone else has
already copied the original data buffer and you do not
need to overwrite.

Questions:
1.  What is nfcache used for?  Alot of people seem to
set it, few examine it.  I am wondering if it could be
used to help indicate a data buffer is 'dirty'.
2.  Pointers in sk_buff.  I likely will have the copy
buffer as a pointer off the sk_buff structure.  I am
wondering if there will be a concern with skb
clone/copy.
3.  What common routine, if any, would be used for
retransmit?  I was thinking tcp_transmit_skb().  At
the start I could check for copy data and revert if
there is any. 
4. Intialization.  I need a good spot to initially
clear the data pointers and then a second one to just
clear the active size.  I believe I know the area to
clear the active size, but any ideas on either would
be good.

If all goes well and this seems like something which
could be used, I would work on generating a patch
against the latest 2.4.x in addition to my slightly
older rev need...
-Scott


		
__________________________________ 
Do you Yahoo!? 
The all-new My Yahoo! - What will yours do?
http://my.yahoo.com 
