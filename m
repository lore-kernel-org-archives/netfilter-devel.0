From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: more about martians
Date: Thu, 22 Apr 2004 09:54:31 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404220943170.1524-100000@filer.marasystems.com>
References: <20040422033242.86850.qmail@web40706.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: udo <udovdh@yahoo.com>
In-Reply-To: <20040422033242.86850.qmail@web40706.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Apr 2004, udo wrote:

> I only want to offer ssh to the outside world (lan and
> wan) on port 22 while still being able to run sshd at
> non-root privs.
> Say port 2222 for non-root reasons but port 2222 must
> not interfere and best not be visible to the outside
> world.

Then set up a private IP alias (on the lo interface if you like, does not
matter), firewall all access to that IP just in case and NAT the SSH
sessions to this IP, not 127.X.

Or simply run SSH on port 2222, nat to this port and firewall any direct 
access to port 2222 with a "-j REJECT --reject-with tcp-reset" to make it 
look like port 2222 is not used.

> > The loopback addresses (127.X/8) are handled very
> > special.
> 
> I found out.
> Why?

Because it is considered a security violation if these is accessed from 
outside the box.

> It's just another interface.

lo is just another interface, and you can give any IP addresses to it.

127.X is not just another IP. It is the loopback IP address range defined 
by IP as not reachable outside the box. And when you ask iptables to NAT 
sessions to this IP you make the TCP/IP stack very upset thinking that 
someone is trying to abuse your server. As iptables runs outside of the 
TCP/IP stack it looks to your TCP/IP stack as if the sending station did 
attempt to send packets addressed to 127.0.0.1.

It is not lo that is hidden from the outside world, it is the 127.X IP 
addresses.

Regards
Henrik
