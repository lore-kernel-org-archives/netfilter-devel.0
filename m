From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:NAT and NFS
Date: Thu, 20 Mar 2003 10:56:24 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303200056.h2K0uPC25615@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Alexander Gun" <Alexander.Gun@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Howdy,

That's a good question.  I updated/rewrote an old RPC module, to support
the newnat framework (the iptables code that I believe is now standard
in 2.4.20 kernel series).

You get details of the code from here;
  http://www.netfilter.org/documentation/pomlist/pom-extra.html#rpc

The long and the short of it is that I didn't test NATting ... so I don't know
if it will work or not ... we did theorise about it ... but never too seriously.
Note though, that I considered the reverse scenario .. where the NFS
box was on the  "outside" and that the clients were being NATd.

It may work ..

Let me know how you go.  If it requires changes, and you're prepare to
test them, then I can prolly get some time together to make the changes
you need.




----- Original Message -----
>From: "Alexander Gun" <Alexander.Gun@gmx.de>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  NAT and NFS
>Date: Thu, 20 Mar 2003 00:42:02 +0100
>
> hi all
> 
> is it possible to share a nfs-filesystem via a NATed host ?
> 
> 
> 
>         ----------------
> 	- NFS - Server -
> 	----------------
> 	       + 129.187...
>                +
> 	       +
> 	       +
> 	       + 129.187....
> 	----------------
> 	-   NAT Host   -
> 	----------------
>                + 192.168....
> 	      +++
> 	     + + +
> 	    +  +  +
> 	   +   +   +
> 	  +    +    +
> 	 +     +     +
> 	+      +      +
>        +       +       +  192.168...
>  ------------------------------
> NFS client1    client2   client3 ....
> -------------------------------
> 
> 
> question: is it possible or not ?
> 
> mfg
> ag
> 
> 
> 
> -- 
> -------------------------------------------
> in a world without fences
>    ---   who needs gates ???
> 
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
