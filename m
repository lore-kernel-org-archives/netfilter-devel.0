From: MaXxX <maxxx@anime-h.com>
Subject: terminating connections when an interface goes down
Date: Mon, 15 Mar 2004 13:02:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <21127330.20040315130231@anime-h.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hello.

Having recently switched to a faster ISP but with dynamically assigned
(and forcibly changed every 24h) IP, I'd like netfilter to TERMINATE
all active connections when the IP changes. Some programs behave very
badly when their connections are left to time out, and some services
ban a user for quite a long time when they detect a double login (and
that's how a timeout-IPchange-relogin sequence looks to them)... I
believe that for many dynamic IP users this might be a great addition
to netfilter, and I'd be willing to code it in, abilities permitting.

Terminating a connection on the NAT side seems fairly easy. A FIN
packet with seq=0 tricks the NATted machine into sending an ACK with a
corrected seq, and a RST in response to it closes the connection. On
the Internet side, however, things are much more hairy, as my IP
address has just changed and there is no way to receive an ACK
response, besides that sending anything out is going to require
spoofing the previous IP. It seems to me that I'd have to make
netfilter keep an internal table of seq numbers (which I suspect it
already has, to NAT properly?) and use it to send a spoofed RST. And
all of it before netfilter cleans out ip_conntrack, if it's going to
be used at all in this case, that is.

If I were to add such an option to netfilter, given my fair but not
excellent C capabilities, what source file should I be mostly looking
at? And can I hope for some guidance along the way, if some
experienced developer finds my idea worthy of it?

Thanks.

-- 
 |\  /|      \~~~/     \~~~/
 | \/ |  /\   > <  \~/  > <    ICQ# 3146019
 |____| /__\ /___\ /_\ /___\    IQ# 3.14159
"This is Pearl Harbor! Japanese aircraft incom-" NO CARRIER




-- 
 |\  /|      \~~~/     \~~~/
 | \/ |  /\   > <  \~/  > <    ICQ# 3146019
 |____| /__\ /___\ /_\ /___\    IQ# 3.14159
Random church bulletin blooper: This being Easter Sunday, we will ask
Mrs. Lewis to come forward and lay an egg on the altar.
