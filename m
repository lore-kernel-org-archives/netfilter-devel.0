From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:Nat Code Confusion
Date: Fri, 20 Jun 2003 14:16:39 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306200416.h5K4Gee29269@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Ricky Foo" <blue_pion@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hey Ricky,

  The direction is relative to the protocol being filtered - ie .. in rsh, the
out of band port is sent in the original direction, and the reply destination
is affected.  I remember from my work though that I felt the source and
dest features were always back to front .. but I think that this is because
we are in the kernel .. so writes are reads .. etc ad nauseum.

  Harald may or may not be the spokesman, but he's always right -- cause
he holds the CVS keys, so he can't be wrong  ;-))


----- Original Message -----
>From: "Ricky Foo" <blue_pion@hotmail.com>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  Nat Code Confusion
>Date: Fri, 20 Jun 2003 03:51:03 +0000
>
> Hi,
> 
> The confused one is back. As usual, a couple of grey areas:
> 
> 1.  Under the data_fixup section for nat, e.g. amanda, there's this line:
> 
>          newip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
> 
>      What's the rationale for selecting the direction to use?
> 
> 2.  Under the nat_expected similar for amanda, the following lines:
> 
> 	newdstip = ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip;
> 	newsrcip = master->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
> 
>      Again, what's the rationale for selecting the direction and in each 
> case, ct or master to use?
> 
> 
> 3. Just a wild observation. Is the Harald the official spokesman for 
> netfilter as it seems he's the only guy
>     answering all the questions.
> 
> Ok, that's it.
> 
>     Ricky
> 
> _________________________________________________________________
> Keep track of Singapore stock prices. http://www.msn.com.sg/money/
> 
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
