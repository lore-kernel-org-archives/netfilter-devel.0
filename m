From: James Morris <jmorris@intercode.com.au>
Subject: Re: [libipq] Buffer size
Date: Sat, 15 Jun 2002 09:36:07 +1000 (EST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Mutt.LNX.4.44.0206150933330.12359-100000@blackbird.intercode.com.au>
References: <1147.131.227.137.82.1024071685.squirrel@ike.ee.surrey.ac.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: eem1wc@eim.surrey.ac.uk
In-Reply-To: <1147.131.227.137.82.1024071685.squirrel@ike.ee.surrey.ac.uk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 14 Jun 2002 eem1wc@eim.surrey.ac.uk wrote:

> Hi... 
> 
>    I am currently using iptables (1.2.5) and libipq to develop a user program 
> (using the QUEUE target) that would introduce an extra delay for packets going 
> through a bridge (bridge-utils-0.9.5). While using ping, the program works 
> fine. But when i test it with Microsoft Netmeeting to transmit voice (no video 
> yet), i quickly receive a message as below:-
> 
> read(): Failed to received netlink message: No buffer space available
> 

This is the kernel side socket buffer running out of space because the 
userspace application can't keep up with the traffice.

> My questions:
> [1] how big is this buffer?
> [2] how can i go about to solve this problem? I typically need to introduce a 
> round-trip delay of 500ms (i.e. 250ms from src to dest through the bridge)?
> [3] can i do anything to enlarge this buffer?
> 

Please see:
http://lists.samba.org/pipermail/netfilter-devel/2001-June/001346.html

Time to add this to the FAQ...


- James
-- 
James Morris
<jmorris@intercode.com.au>
