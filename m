From: Jeremy Kerr <jeremy@redfishsoftware.com.au>
Subject: Re: How to take over TCP connection from userspace process?
Date: Wed, 22 Oct 2003 14:15:23 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310221415.23403.jeremy@redfishsoftware.com.au>
References: <007001c3984f$aff2f740$d32f110a@yrhd>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <007001c3984f$aff2f740$d32f110a@yrhd>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> What I need is: after I authenticated TCP connection A(host A connected to
> me) and TCP connection B(host B connected to me), then let what host A send
> (through TCP connection A)directly forward to host B(through TCP connection
> B) in the kernel ,meanwhile, what host B send directly forward to host A in
> the kernel.

Sounds like the LVS project's TCP splicing code is what you're after:

http://www.linuxvirtualserver.org/software/tcpsp/index.html

This allows you to connect ('splice') two sockets together in userspace, so 
the subsequent forwarding is handled within the kernel. I've never used it 
myself though.


Jeremy
