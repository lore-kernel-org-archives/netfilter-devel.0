From: James Morris <jmorris@intercode.com.au>
Subject: Re: problem with libipq and userprocess and 'clean' exit
Date: Thu, 13 Jun 2002 23:07:54 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0206132246250.5686-100000@blackbird.intercode.com.au>
References: <200206131356.23597@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206131356.23597@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 13 Jun 2002, Henrik Nordstrom wrote:

> On Thursday 13 June 2002 13:50, James Morris wrote:
> 
> > Nothing to worry about, there is currentl no way for the ip_queue
> > module to know that the user process has exited (unless another
> > process starts using the queue).
> >
> > The kernel module also ensures that all packets are fed back into
> > the stack, no matter what the userspace application does.
> 

Actually, the module does detect that the process has exited if it tries  
to send a packet to userspace.  At this point, it will flush the queue and 
not queue any more packets unless another process sends a queue mode
message.
  
If the user process exits and no new packets arrive, any queued packets   
will stay queued until the module is removed or any associated device is  
downed.  This is what is meant by the kernel module ensuring that all 
queued packets make it back to the stack.

> So one way to get out of the situation is to remove the QUEUE target 
> to stop new packets from being queued, and then start a dummy program 
> that attaches to the queue? This should both stop new packets from 
> being queued and release any pending packets, right?
> 

Yes, although, it would be better to get a notifcation from Netlink when 
the process closes the socket -- the kernel code and userspace semantics 
could be then made much cleaner.


- James
-- 
James Morris
<jmorris@intercode.com.au>
