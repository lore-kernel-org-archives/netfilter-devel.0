From: Gerry Skerbitz <gsker@attbi.com>
Subject: bug in iptables-save/iptables-restore
Date: Sun, 17 Nov 2002 09:23:27 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DD7B46F.3050006@attbi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

I installed narc to build some firewall rules for me, but to fit it in 
well with the RedHat8 installation,
I wanted to put its rules in /etc/sysconfig/iptables.  I ran
iptables-save > /etc/sysconfig/iptables
Then I tried restoring it using
iptables-restore /etc/sysconfig iptables and got these errors:
#~>/sbin/iptables-restore /etc/sysconfig/iptables
iptables-restore v1.2.7a: length invalid: `!40'

Try `iptables-restore -h' or 'iptables-restore --help' for more information.

here are the offending lines created by iptables-save:
#~>iptables-save | grep length
-A CUST_LOG -p tcp -m length --length !40:68 -j LOG --log-prefix 
"PACKET_LENGTH_BAD: " --log-level 7 --log-tcp-options --log-ip-options
-A CUST_LOG -p tcp -m length --length !40:68 -j DROP
#~>

I just did some digging and figured out that the exclamation point 
should go before the --length 40:68.  I guess that's
what iptables-save should really do and clearly it's what narc does when 
it sets up the rule.

No reply necessary.   Thanks for all the work you do!

Gerry
