From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Sanity Check: Getting priority information to QUEUE (long)
Date: Wed, 31 Mar 2004 22:26:05 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403312212050.24487-100000@filer.marasystems.com>
References: <20040331151749.6211.qmail@web13903.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Scott MacKay <scottmackay@yahoo.com>
In-Reply-To: <20040331151749.6211.qmail@web13903.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 31 Mar 2004, Scott MacKay wrote:

> In the QUEUE userspace, it would be really useful if I
> could get the priority information on the delivered
> packet.  This would help me if I register QUEUE for
> both raw/PREROUTING and mangle/PREROUTING to know
> where I am.

Right.

You do however have the nfmark field which can be used for pretty much any 
purpose..

> You do not have the exact priority within the hook
> Dirty.  My idea for dirty is 'hey, hook is like 5
> values 0-4 and I don't see it growing into a billion
> more options.  priorities are well within a -32K to
> 32K range.  "hook" is an unsigned int (4 bytes). 
> Masking time!!!! 

What is wrong with adding a new field for this? (or even splitting the 
hook field in two 16 bit fields for the purpose..)

Yes, adding a new field with break binary compatibility, but so will 
adding data to the hook field by masking.

> The last idea: add a field to the ipq_packet_msg
> structure.  As ugly as the prev are, I hate this the
> most since there is no way a QUEUE will know this is
> there anyways and if not recompiled against an updated
> header

I do not consider this a problem.

If this really worries you then extend ip_queue with a new mode or option 
to enable the use of this extended ipq_packet_msg_v2 structure. 
(adding an IPQM_VERSION option comes to mind...)

Regards
Henrik
