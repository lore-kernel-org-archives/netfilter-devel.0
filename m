From: Laurens Blankers <laurens.blankers@gmail.com>
Subject: PPTP conntrack NOT working in kernel 2.6
Date: Thu, 20 Jan 2005 14:52:16 +0100
Message-ID: <7a182bd905012005523e78f4c6@mail.gmail.com>
Reply-To: Laurens Blankers <laurens.blankers@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org, laforge@netfilter.org
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

Hello Harald & all,

I'm having problems with PPTP conntrack when using kernel 2.6.10 and
pom-ng from SVN. The problem is a bit difficult to explain so please
read carefully.

I have a server which connects to the internet and acts as a
masquarading NAT gateway for several (Windows) PCs. I am trying to
establish a PPTP connection from a Windows PC thought the Linux NAT
gateway to a remote PPTP server somewhere on the inet. This works for
when a single PC connects to a remote PPTP server, but not when
multiple local PCs connect to the remote PPTP server. This is because
of limitations in standard Linux conntrack and the reason for the
existance of PPTP conntrack.

So to solve this problem I got PPTP conntrack from pom-ng in SVN and
compiled it as a module. However loading the PPTP conntrack and NAT
modules prevents even a single PC from establishing a connection with
the remote PPTP server.

There are no error messages in the system log. However the firewall
log shows that incoming GRE packets get dropped because they do not
belong to an connection. Obviously the conntrack module is not
working, and even preventing the standard conntrack from working.

The problem gets more complicated though: the server is not connected
to the internet directly but though a PPTP connection (this is a
totally different connection that was described above). Loading PPTP
conntrack also causes problems with this connection.

Certain GRE packets of this PPTP connection that connects my Linux box
to the internet get marked as 'invalid', causing my firewall to drop
them. Strangely enough this does not cause the PPTP connection to
fail: internet connectivity stays up.

Also at exactly 60 second intervals the system log shows the following error:

Jan 20 12:40:33 src@beta net/ipv4/netfilter/ip_conntrack_pptp.c: bad csum

I hope I have been able to convey the problem to you, if not please
send me an e-mail and I will try to explain it in another way.

Sincerely,

Laurens
