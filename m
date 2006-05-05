From: Cody Tubbs <tubbs@wispdirect.com>
Subject: ipv4options broken...
Date: Fri, 05 May 2006 10:58:25 -0700
Message-ID: <1146851905.4558.16.camel@mbox>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I've pom'd the latest version, and have iptables 1.3.5 installed on FC4.

Everything works fine except --lsrr and --ssrr.  I'm using "hping --lsrr
<someip> <targetip>" (and --ssrr respectively) to test the ip options.
tcpdump/ethereal show the flags being set correctly, yet ipv4options is
lacking the capability to catch them.

The rest of the ipv4options functionality work fine.

snippet:

$IPTABLES -N LOOSE_SR_MATCH
$IPTABLES -A LOOSE_SR_MATCH -j LOG --log-level info --log-prefix "LSRR:
" --log-tcp-sequence --log-tcp-options --log-ip-options
$IPTABLES -A LOOSE_SR_MATCH -j DROP

$IPTABLES -N STRICT_SR_MATCH
$IPTABLES -A STRICT_SR_MATCH -j LOG --log-level info --log-prefix "SSRR:
" --log-tcp-sequence --log-tcp-options --log-ip-options
$IPTABLES -A STRICT_SR_MATCH -j DROP

$IPTABLES -A INPUT -m ipv4options --lsrr -j LOOSE_SR_MATCH
$IPTABLES -A INPUT -m ipv4options --ssrr -j STRICT_SR_MATCH


(I've tried specifying "-p ip" and -i accordingly as well, all with the
same results).  Again, the rest of the flags work fine, ie: --rr (record
route) catches properly when using "hping -G <targetip>"


-Cody Tubbs
