From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking
Date: Tue, 03 Dec 2002 13:29:50 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DEC252E.7010707@snapgear.com>
References: <Pine.LNX.4.44.0212022036040.16274-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ilguiz Latypov <ilguiz@nit.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Ilguiz Latypov wrote:
> The first attempt to connect to a remote PPTP server (PoPToP) produced an
> error on the server side.  I suspect this could be related to the fact
> that I installed the same PPTP kernel modules on the server side.  I
> understand that those modules are superfluous on the server (PAC) side.

While you don't need the PPTP connection tracking on the
server side, it shouldn't cause the connection to fail.
I've been testing with various combinations of connection
tracking on server/client/firewall.

> The error message is produced by the run time error in encaps_gre() where
> the write() function is called to send a GRE packet.  I wonder if that
> issue is related to the one you mentioned in the bottom of your message.
> 
> It appears to me that I was able to establish 2 parallel connections from
> Windows workstations later and observe correct reply rewriting on the
> client firewall.  So the run time error might not be always reproduced.
> 
> =============================================================================
> pppd: sent [LCP ConfReq id=0x1 <asyncmap 0x0> <auth chap 81> <magic 0x3f3847ac> <pcomp> <accomp>]
> pptpd: GRE: xmit failed from decaps_hdlc: Operation not permitted
> pptpd: CTRL: PTY read or GRE write failed (pty,gre)=(16,17)
> =============================================================================

You get an operation not permitted error if you have a filter
rule on the server that drops the GRE packet in the OUTPUT
chain.

I think I'm close to solving the problems with my patch, so
I'll post a new version shortly.

Regards,
Phil

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances
