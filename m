From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Fwd:Re: 2.4.20 and user space ICMP REDIRECT
Date: Tue, 17 Feb 2004 21:59:37 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402171159.i1HBxbU12123@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
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


Hello Devel,

  I'm cleaning out my email and I wanted to get this published for
your review.  A long time ago I was looking to inject ICMP redirects
into a VLAN (ordinary LAN to Linux) for some testing. 

Archived;
  http://lists.netfilter.org/pipermail/netfilter-devel/2003-March/010730.html
  http://lists.netfilter.org/pipermail/netfilter-devel/2003-March/010731.html

  I ended up deciding that the issue wasn't netfilter related, and 
took it to the linux-net list .. but I was set aside, and didn't have 
time to investigate it properly (fair enuff).

  Following my public/archived posts, two unrelated gentlemen 
have independantly confirmed that the issue is a netfilter issue --
that compiling the kernel without netfilter fixes the problem -- even
in 2.6.0 (see below).

  I still haven't got time to investigate this properly.  But I wanted to
get this info updated in the public domain in case anyone else is 
looking for this. 



Regards,






Forwarded message follows:
>Subject:  Re: 2.4.20 and user space ICMP REDIRECT
>Date: Tue, 27 Jan 2004 19:59:06 +0200
>
> Hello, Ian Latter.
> 
> 
> >   No, I didn't solve this problem ... I didn't get the time to attack it
> > properly (ie, to recompile different kernels of different versions,
> > to find where the change occurred and what that difference 
> > was).
> > 
> >   It has been suggested that this problem is caused by netfilter,
> > and that removing netfilter (disabling it in the .config) may fix the
> > problem ... I didn't experience that, but one other did.
> 
> Thank you, it may be true.
> At 2.6.0 kernel without netfilter packets are injected successfully.
> 




--
Ian Latter
Internet and Networking Security Officer
Macquarie University

 Meet me at the Australian Unix and open systems
   User Group (AUUG) Security Symposium; 2004
  http://www.auug.org.au/events/2004/security/
