From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Thu, 8 Mar 2007 16:36:03 +0100
Message-ID: <200703081636.03226.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703051806.13996.thomas.jarosch@intra2net.com>
	<45EC5D53.3070901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45EC5D53.3070901@trash.net>
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

Hello Patrick,

On Monday, 5. March 2007, you wrote:
> > I'm not sure if I understand you correctly, shouldn't it already be
> > possible to add an expectation via "conntrack -I expect"?
>
> Yes, but currently expectations always need a master connection
> with a helper assigned.

Thanks for clearing this up. Is this change easy to do, like it would
take you ten minutes or is it a more complex task?

> > Another idea came to my mind today: If the socks server needs to be
> > patched anyway, would it be useful to set a connmark via an ioctl on the
> > socket?
>
> connmark isn't possible since the sending side of the socket
> only deals with packets before the have been associated with
> a conntrack entry. But you could use normal marks, IIRC
> Balazs Scheidler <bazsi@balabit.hu> posted a patch for this
> to netdev about 1.5 years ago.

I was unable to find the patch, too bad the lovely patchwork system wasn't in 
place at that time. Anyway, ipt_owner works for outgoing connections so after 
giving it another thought it a) already works b) is one patch less to the 
socks proxy -> ipt_owner is fine for this.

> > Normal firewall rules could then be used for incoming and especially
> > outgoing connections from the socks server.
>
> Incoming connections don't work, the receiving socket is not known
> while the packet is handled by netfilter.

Ok, thanks.

I'm still wondering how other people are running a socks server
together with an iptables firewall. I can't imagine
they leave all incoming ports open...

Cheers,
Thomas
