From: Scott MacKay <scottmackay@yahoo.com>
Subject: Re: Sanity Check: Getting priority information to QUEUE (long)
Date: Wed, 31 Mar 2004 13:10:11 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331211011.97404.qmail@web13906.mail.yahoo.com>
References: <Pine.LNX.4.44.0403312212050.24487-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403312212050.24487-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Wed, 31 Mar 2004, Scott MacKay wrote:
> 
> You do however have the nfmark field which can be
> used for pretty much any 
> purpose..
Very true, but I was hoping to use that for other
things.  As is, I would like a persistent field in
addition to MARK, but that is a different story.  I
think I will check the patch-o-matic for other add-ons
which may serve this function...

> If this really worries you then extend ip_queue with
> a new mode or option 
> to enable the use of this extended ipq_packet_msg_v2
> structure. 
> (adding an IPQM_VERSION option comes to mind...)
That actually may be the cleanest...I have not looked
at how to send commands to the ip_queue directly, but
that could save a module insert and allow me to extend
alot more than I currently am doing.  

Oh, also, from what I found to answer one of my own
questions: the info elem hook does in fact contain a
pointer to the nf_hook_ops for what invoked this app. 
This makes the hook & priority from that structure
available to me, wohoo!




__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
