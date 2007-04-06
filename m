From: Patrick McHardy <kaber@trash.net>
Subject: Re: What to do with malformed l4proto packets? (resend)
Date: Fri, 06 Apr 2007 20:29:10 +0200
Message-ID: <46169176.2000507@trash.net>
References: <46168530.9070604@psc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: John Heffner <jheffner@psc.edu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46168530.9070604@psc.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

John Heffner wrote:
> We have someone on the end of a DSL line that seems to be
> non-deterministically corrupting some of his packets (a rate of ~1e-5)
> in a way that causes the TCP checksum to fail.  While he hopes to get
> this situation remedied, the immediate problem is that his connections
> that go through our firewall are getting reset every time a corrupted
> segment is received.
> 
> AFAICT, what's happening is that tcp_error() finds the TCP checksum
> wrong, returning -NF_ACCEPT back up to nf_conntrack_in(), which quits
> and sends NF_ACCEPT back up.  So we have a TCP packet not associated
> with a connection, so our firewall rules send back a RST.
> 
> So, the question is: is there any reason to ACCEPT TCP segments with
> known bad checksums?


The REJECT target verifies the checksum, so this shouldn't happen.
Are you sure its the REJECT target thats sending the RST?

In either case you should probably just drop state INVALID packets
since this can also happen for retransmits etc. when TCP window
tracking doesn't like the packet.
