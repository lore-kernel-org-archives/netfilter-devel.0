From: Ilguiz Latypov <ilguiz@nit.ca>
Subject: Re: PPTP connection tracking
Date: Mon, 2 Dec 2002 21:49:47 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0212022036040.16274-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: philipc@snapgear.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Philip,

Thank you for sharing the patch.  I observed the same problem where the
client's firewall would not rewrite the replies.  That is, the replies
could be seen arriving on the external interface but not on the internal
interface.

With the aid of ethereal I noticed that the first GRE packet between the
client and the server might be the one coming from the server (with
encapslated PPP LCP request).

I am a novice in Linux kernel programming so I could only test your patch.

The first attempt to connect to a remote PPTP server (PoPToP) produced an
error on the server side.  I suspect this could be related to the fact
that I installed the same PPTP kernel modules on the server side.  I
understand that those modules are superfluous on the server (PAC) side.

The error message is produced by the run time error in encaps_gre() where
the write() function is called to send a GRE packet.  I wonder if that
issue is related to the one you mentioned in the bottom of your message.

It appears to me that I was able to establish 2 parallel connections from
Windows workstations later and observe correct reply rewriting on the
client firewall.  So the run time error might not be always reproduced.

Thanks,

--
Ilguiz Latypov
Net Integration Technologies, Inc

tel. +1 (514) 281 9191 x 117

=============================================================================
pppd: sent [LCP ConfReq id=0x1 <asyncmap 0x0> <auth chap 81> <magic 0x3f3847ac> <pcomp> <accomp>]
pptpd: GRE: xmit failed from decaps_hdlc: Operation not permitted
pptpd: CTRL: PTY read or GRE write failed (pty,gre)=(16,17)
=============================================================================
