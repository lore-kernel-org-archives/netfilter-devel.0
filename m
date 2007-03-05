From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Mon, 5 Mar 2007 18:06:13 +0100
Message-ID: <200703051806.13996.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703021359.35886.thomas.jarosch@intra2net.com>
	<45E9A144.1050600@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45E9A144.1050600@trash.net>
Content-Disposition: inline
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

Hi Patrick,

On Saturday, 3. March 2007, Patrick McHardy wrote:
> > Socks allows a client to bind a port on the external IP of the server
> > and then wait for an incoming connection. Would it make sense to write a
> > conntrack module which parses the communication between socks client and
> > server and then adds the incoming connection to conntrack?
>
> Not sure if its worth the effort. It also doesn't seem to fit the helper
> model really well since the expectation is only relevant for the proxy
> itself, not for the firewalls in between. Or does the proxy open a new
> connection to the client when an external connection arrives?

The data gets passed over the existing connection. But you are right,
it's only useful if the proxy runs on the same machine. For socks
servers this is not uncommon, though the effort is not worth it.

> > The easier solution would be to patch the socks server to execute a
> > script if the client requests to bind a port on the server. The
> > connection could be added via the userspace conntrack tool, right?
>
> That should work. We could also add support for helperless expectations
> for this, which will properly deal with NAT automatically.

I'm not sure if I understand you correctly, shouldn't it already be possible 
to add an expectation via "conntrack -I expect"?

Another idea came to my mind today: If the socks server needs to be patched 
anyway, would it be useful to set a connmark via an ioctl on the socket?
Normal firewall rules could then be used for incoming and especially
outgoing connections from the socks server.

Cheers,
Thomas
