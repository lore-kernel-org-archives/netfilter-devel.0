From: Willy Tarreau <willy@w.ods.org>
Subject: Re: filter for adding/checking TCP MD5 option
Date: Fri, 23 Jan 2004 08:11:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040123071109.GB16708@alpha.home.local>
References: <E1Aitrb-0004cA-00@services3.virtu.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Remco van Mook <remco@virtu.nl>
Content-Disposition: inline
In-Reply-To: <E1Aitrb-0004cA-00@services3.virtu.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Tue, Jan 20, 2004 at 12:12:20PM +0100, Remco van Mook wrote:
 
> # iptables -t mangle -A OUTPUT -p tcp -d 1.2.3.4 --dport 179 -j TCPMD5
> --md5-key=s3cr3t
> # iptables -t mangle -A PREROUTING -p tcp -s 1.2.3.4 --dport 179 -j TCPMD5
> --md5-key=s3cr3t

 
> The first line would do something as follows:
> - decrease MSS to make the extra option fit (a staggering 18 bytes extra in
> the TCP header)
> - calculate the MD5 based on the key and the information contained in the
> packet
> - insert the TCP MD5 option field, recalculate checksum and send the packet
> on its way

ok

> The second line would:
> - check whether the MD5 matches the key
> - DROP the packet if it doesn't match
> - if the MD5 matches, strip off the MD5 option field, recalculate checksum
> and treat the packet as if nothing happened

nok. the target should not drop the packet itself, you should write a match
which only accepts valid MD5. And the target would only have to strip MD5.
This allows all standard constructions, logging, etc... :

# iptables -t mangle -N novalidmd5
# iptables -t mangle -A novalidmd5 -j LOG --log-prefix "invalid MD5: "
# iptables -t mangle -A novalidmd5 -j DROP

# iptables -t mangle -A PREROUTING -p tcp -s 1.2.3.4 --dport 179 ! -m tcpmd5
 --md5-key=s3cr3t -j novalidmd5
# iptables -t mangle -A PREROUTING -p tcp -s 1.2.3.4 --dport 179 -j STRIPTCPMD5

Moreover, if '-m tcpmd5' without md5key could match any MD5 packet, it would
allow to direct the packet to a user chain reponsible to check between
several known secrets, or to systematically strip the MD5 for example.

> As I'm a complete newbie when it comes to netfilter development, could
> anybody provide me some pointers on how to do
> this in the right way ?

I think that everyone does the same : take a simple match/target, remove
the simple code, insert yours and start to understand how it works ;-)

Cheers,
Willy
