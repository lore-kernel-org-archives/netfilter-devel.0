From: Internet Protocol version Six <inet6@mail.be>
Subject: IPv6 Router and NAT/connection tracking
Date: Mon, 23 Jun 2003 18:41:48 +0200 (GMT+02:00)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <184695404.1056386508500.JavaMail.Administrator@pumbaa>
Reply-To: Internet Protocol version Six <inet6@mail.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello all,

I have a box that's configured as a firewall/NAT (IPv4) and router
for IPv6, which is doing it's job fine, well, fine.., IPv6
connections keep timing out, they work for a second or 30 and then
it timesout -> connections, ping6, traceroutes, ... from the
Internet to the IPv6 address behind the router don't work anymore.
Also if I do a ping6 or make a connection to a remote IPv6 host on
the Internet it doesn't work, however if I ping6 the router from the
other machine, everything works again...for about 30 seconds to 5
minutes, and then the problem begins again...

I was told that this is caused by NAT/connection tracking. Is there
*any* solution to this? This is really annoying as I *need* NAT, but
also want to give IPv6 connectivity to other machines on the LAN.

Your help is greatly appreciated.

-Robby
-----------------------------------------------------
Mail.be, WebMail and Virtual Office
http://www.mail.be
