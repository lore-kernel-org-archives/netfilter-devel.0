From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: FW: [PATCH net-2.6.25] Add packet filtering based on process'ssecurity context.
Date: Sat, 24 Nov 2007 22:03:16 +0900
Message-ID: <200711242203.HAJ34372.FFFOMOJOVtHQSL@I-love.SAKURA.ne.jp>
References: <Xine.LNX.4.64.0711231005270.4252@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wine.ocn.ne.jp ([122.1.235.145]:64338 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbXKXNDV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Nov 2007 08:03:21 -0500
Received: from CLAMP (p1195-ipbf1702marunouchi.tokyo.ocn.ne.jp [124.102.84.195])
	by smtp.wine.ocn.ne.jp (Postfix) with ESMTP id 7EAAA3C08
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Nov 2007 22:03:19 +0900 (JST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I'm forwarding these mails since netfilter-devel's address has changed.

http://marc.info/?l=linux-netdev&m=119573856328335&w=2

------- Forwarded Message
 From: James Morris <jmorris@namei.org>
 To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,"David S. Miller" <davem@davemloft.net>,linux-security-module@vger.kernel.org,Patrick McHardy <kaber@trash.net>, netfilter-devel@lists.netfilter.org,Stephen Smalley <sds@tycho.nsa.gov>
 Subject: Re: [PATCH net-2.6.25] Add packet filtering based on process'ssecurity context.
 Date: Fri, 23 Nov 2007 10:29:46 +1100 (EST)

On Thu, 22 Nov 2007, Tetsuo Handa wrote:

> This patch allows LSM modules filter incoming connections/datagrams
> based on the process's security context who is attempting to pick up.
> 
> There are already hooks to filter incoming connections/datagrams
> based on the socket's security context, but these hooks are not
> applicable when one wants to do TCP Wrapper-like filtering
> (e.g. App1 is permitted to accept TCP connections from 192.168.0.0/16).

This functionality looks like it could be useful in that we currently have 
no direct security mapping from incoming packet to user process, but only 
to the receiving socket, as you mention.  For SELinux, it may help us 
simplify/clarify policy.

It's also been long-desired for netfilter/iptables, to allow ipt_owner to 
work cleanly for incoming packets.

So, this probably needs to be implemented in a way which works for both LSM 
and netfilter.  There have been several discussions on the issue from the 
netfilter side, although I don't know what the latest status of that is 
(I've expanded the cc list to hopefully get some more feedback).

 From memory, one approach under discussion was to add netfilter hooks to 
the transport layer, which could be invoked correctly by each type of 
protocol when the target process is selected.

If this is done for netfilter, then an LSM hook is probably not needed at 
all, as security modules can utilize netfilter hooks directly.

> Precautions: This approach has a side effect which unlikely occurs.
> 
> If a socket is shared by multiple processes with differnt policy,
> the process who should be able to accept this connection
> will not be able to accept this connection
> because socket_post_accept() aborts this connection.
> But if socket_post_accept() doesn't abort this connection,
> the process who must not be able to accept this connection
> will repeat accept() forever, which is a worse side effect.
> 
> Similarly, if a socket is shared by multiple processes with differnt policy,
> the process who should be able to pick up this datagram
> will not be able to pick up this datagram
> because socket_post_recv_datagram() discards this datagram.
> But if socket_post_recv_datagram() doesn't discard this datagram,
> the process who must not be able to pick up this datagram
> will repeat recvmsg() forever, which is a worse side effect.
> 
> So, don't give different permissions between processes who share one socket.
> Otherwise, some connections/datagrams cannot be delivered to intended process.

These semantics changes are concerning, and lead me to wonder if there are 
any more.  Needs more review by networking folk.



- James
-- 
James Morris
<jmorris@namei.org>


------- End of Forwarded Message

------- Forwarded Message
 From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
 To: jmorris@namei.org
 Cc: herbert@gondor.apana.org.au, netdev@vger.kernel.org, davem@davemloft.net,linux-security-module@vger.kernel.org, kaber@trash.net,netfilter-devel@lists.netfilter.org, sds@tycho.nsa.gov
 Subject: Re: [PATCH net-2.6.25] Add packet filtering based on process'ssecurity context.
 Date: Sat, 24 Nov 2007 11:14:50 +0900

Hello.

James Morris wrote:
> From memory, one approach under discussion was to add netfilter hooks to 
> the transport layer, which could be invoked correctly by each type of 
> protocol when the target process is selected.
> 
> If this is done for netfilter, then an LSM hook is probably not needed at 
> all, as security modules can utilize netfilter hooks directly.

Patrick McHardy says (at http://marc.info/?l=linux-netdev&m=118495005800410&w=2 )
"Even with socket filters netfilter doesn't know the final receipient
 process, that is not known until it calls recvmsg and the data is read,
 which is too late for netfilter."



> > Precautions: This approach has a side effect which unlikely occurs.
> > 
> > If a socket is shared by multiple processes with different policy,
> > the process who should be able to accept this connection
> > will not be able to accept this connection
> > because socket_post_accept() aborts this connection.
> > But if socket_post_accept() doesn't abort this connection,
> > the process who must not be able to accept this connection
> > will repeat accept() forever, which is a worse side effect.
I think this change is needed regardless of whether to use connection filtering or not.
Currently, SELinux doesn't use socket_post_accept().

|  * @socket_post_accept:
|  *	This hook allows a security module to copy security
|  *	information into the newly created socket's inode.

But if one wants to *copy* security information to accept()ed socket,
the location after fd_install() is too late to copy
because the userland process can access accept()ed socket's fd
whose security information is not copied yet.

Also, if one wants to *assign* security information to accept()ed socket,
it might attend memory allocation which can fail.
So, use of void for socket_post_accept() deprives a security module of a chance to
abort this connection if the security module failed to *assign* security information.

Regards.

-
To unsubscribe from this list: send the line "unsubscribe netdev" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


------- End of Forwarded Message

