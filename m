From: Scott MacKay <scottmackay@yahoo.com>
Subject: Sanity Check: Getting priority information to QUEUE (long)
Date: Wed, 31 Mar 2004 07:17:49 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331151749.6211.qmail@web13903.mail.yahoo.com>
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

Hi! 
Sorry if this post rambles :)
Thanks again to Henrik on the great info for frags and
the order of things...

I had a need in the QUEUE target with an idea on how
to get there.  I wanted to pass it by here quickly as
a sanity check on my thinking before I burn down my
kernel.  I do not see any current method that priority
is passed to the QUEUE target.  No matter my solution,
it will have elements of ugliness since I will need to
alter the kernel code for ip_queue.

In the QUEUE userspace, it would be really useful if I
could get the priority information on the delivered
packet.  This would help me if I register QUEUE for
both raw/PREROUTING and mangle/PREROUTING to know
where I am.

I see in ip_queue.c that the key function hooked is
ipq_enqueue_packet.  This guy gets both the skb and
also a nf_info structure.  Looking at the nf_info, it
has a "nf_hook_ops *elem".  This structure looks like
what is used to register locations/priorities .

Question:  The nf_info's elem field which gets passed
to hooked functions: does it just contain 0-1
nf_hook_ops structures or 0-x?  If 0-1, then I would
guess the entry has the elem->priority field which
would be the priority this hook rode in on.  If that
is not the case, then how could I use the nf_hook_ops
to get the priority info?  Is there ver a case where
elem==NULL?  It would seem not likely, since all hooks
look like they register the nf_hook_ops they serve. 
The concern I have about the data in elem is that the
hook field (which also exists in the nf_hook_ops) is
*not* gotten from this structure during QUEUE
packaging, but rather from the nf_info itself.  I am
hoping the nf_info's hook field is just a redundant
thing.

ipq_enqueue_packet puts together it's ipq_queue_entry
stuff and calls ipq_build_packet_message which is
where the packaging to userspace occurs.  It populates
a ipq_packet_msg structure which is what will get sent
to the userspace.  This structure does have an int
hook field which is the proper hook for the packet. 
It lacks a priority field though.  

Providing I can get the priority from the incoming
structures, the next part is how to deliver it up.
I have 3 ways: 'dirty, fast & ugly', 'super dirty', or
cleaner,less compatible.

Dirty.  My idea for dirty is 'hey, hook is like 5
values 0-4 and I don't see it growing into a billion
more options.  priorities are well within a -32K to
32K range.  "hook" is an unsigned int (4 bytes). 
Masking time!!!! 
My dirty idea was to steal 2 bytes from the hook field
being passed up.  I would place the priority in the
upper 2 bits and keep the lower 2 bits for the hook
number.  This has the advantage that I will not alter
the size of the message structure being passed up. 
Ugly, relying on a int being 4 bytes and such.  This
is really nice since it just needs a kernel recompile.
Along the same though but a different field, I could
do the same to the mark field.  I plan to use it, but
well within a 2 byte range; no need for 4 bytes that
it has.  
Neither of the above hurt anyone (other than different
people's QUEUEs :) as the data is single direction: it
never gets updated back in the kernel (though I think
there may be a patch to allow mark updates).
The last idea: add a field to the ipq_packet_msg
structure.  As ugly as the prev are, I hate this the
most since there is no way a QUEUE will know this is
there anyways and if not recompiled against an updated
header, it will have a bad offset for the data field
and stuff.  As 'proper' as this may be, it seems like
it could cause the most damage to others.

As a nice compromise I was thinking this:
What if I altered the code to overload hook, since
priority is most related to hook anyways.  I could
then make a dummy kernel module, something
insmod-able.  When loaded, it does the overload.  When
not loaded, hook acts normally.
It does nothing other than have a flag which
ipq_build_packet_msg tries to read during the
ipq_packet_msg construction (I will need to read up on
how this is done). 



__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
