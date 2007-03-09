From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: 2.6.20: ipt_owner match and INPUT chain
Date: Fri, 9 Mar 2007 11:38:57 +0100
Message-ID: <200703091138.57392.thomas.jarosch@intra2net.com>
References: <200703020946.20765.thomas.jarosch@intra2net.com>
	<200703081636.03226.thomas.jarosch@intra2net.com>
	<45F04F6F.5020103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F04F6F.5020103@trash.net>
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

On Thursday, 8. March 2007, Patrick McHardy wrote:
> > Thanks for clearing this up. Is this change easy to do, like it would
> > take you ten minutes or is it a more complex task?
>
> Without having looked into this in detail, I guess it should be
> in the tens of minutes range. We need this anyway for state
> synchronization since the H.323 helper manually assigns
> unregistered helpers to its children.

Do expectations always need an associated conntrack entry
or could they be added as orphans? I can imagine it will be
quite difficult for the shell script to find
the correct client<->socks server conntrack.

> Great. Just for reference, this is the patch I was talking about:
>
> http://marc.theaimsgroup.com/?l=linux-netdev&m=112870885111441&w=4

Grrr, I really searched for the patch... :-)

> > I'm still wondering how other people are running a socks server
> > together with an iptables firewall. I can't imagine
> > they leave all incoming ports open...
>
> I have no idea. I can only assume most people simply don't allow
> users to open their own external ports on a firewall at all.

True that, but applications like ICQ or home banking software need this 
sometimes. I guess they don't firewall their socks server at all.

Cheers,
Thomas
