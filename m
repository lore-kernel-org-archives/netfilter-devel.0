From: alex <alex@bennee.com>
Subject: Should forwarded packets ever hit the OUTPUT chain?
Date: 08 Nov 2002 08:31:50 +0000
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <1036744310.2708.64.camel@trent.nin>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

As I understood it forwarded packets never went over the OUTPUT chain,
the OUTPUT chain is only to filter what local processes send out. In
trying to debug my firewall (see earlier message on the user list) I can
see the final rule of my to-lan chain (attached to output) dropping
packets when the incomming web connection hangs. My to-lan chain is set
up like this:

    # Filters for stuff going to the LAN. About the only things we need to make
    # sure is that existing connections are maintained (see from-lan).
    # its more or less a mirror of from-lan

    # maintain any existing ssh connections (cannot make new connections)
    /sbin/iptables -A to-lan -d $TRENT -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT
    # return any icmp stuff to TRENT
    /sbin/iptables -A to-lan -d $TRENT -p icmp -j ACCEPT
    # allow name resolution
    /sbin/iptables -A to-lan -d $ZHEER -p tcp --dport 53 -j ACCEPT
    /sbin/iptables -A to-lan -d $ZHEER -p udp --dport 53 -j ACCEPT
    # log stuff
    /sbin/iptables -A to-lan -m limit -j LOG --log-prefix "[Dropped to-lan]"
    /sbin/iptables -A to-lan -j DROP
    # enable to-lan
    /sbin/iptables -A OUTPUT -o $INTIF -j to-lan

I'm womdering if the filtering based on output interface could be the
problem? Perhaps triggering a netfilter bug?

-- 
Alex@Bennee.com
http://www.bennee.com/~alex/
