From: Christopher Soghoian <chris@dubfire.net>
Subject: Netfilter logging from the kernel
Date: Wed, 14 Jul 2004 13:21:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040714132128.A30620@sphinx.mythic-beasts.com>
Reply-To: chris@dubfire.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

We're working on a project here @ IBM Zurich, that will most likely
involve some netfilter stuff.

We're interested in locking down machines, in an attempt to
limit what a hacker can do if he is able to break into them.

All of these machines will have a iptables firewall in place,
limiting the outbound traffic.

Thus, the first thing an attacker would do after breaking in
would be to attempt to remove the firewall rules.

While we cannot defend against this, assuming he has gained root
access, we would at least like to make the machine tamper evident.

Initially, we thought that we could modify the iptables binary to
print out something to syslog every time a change to the rules
is made - however, it would be easy enough for the attacker to
copy over a virgin copy of iptables.

Thus, the logging code must be in the kernel, and not in the
iptables binary.

We would ideally like to see a log message sent to the
syslog every time an iptables rule is added/modified/removed.

Does anyone know if there is anything in place right now that
would allow this?

If nothing exists, how difficult would it be to whip something
like this up? Could you point me to the right part of the code
where I'd need to add my additional functionality.

Cheers,

Chris
