From: Simon Kirby <sim@netnation.com>
Subject: Re: REJECT using invalid data
Date: Fri, 10 Dec 2004 06:49:42 -0800
Message-ID: <20041210144942.GA19709@netnation.com>
References: <Pine.LNX.4.53.0412072347080.2736@bizon.gios.gov.pl>
	<41B642A1.9030807@eurodev.net>
	<20041208005216.GA7958@netnation.com>
	<Pine.LNX.4.53.0412101310210.1288@bizon.gios.gov.pl>
	<20041210131050.GB9398@netnation.com>
	<Pine.LNX.4.53.0412101439530.6072@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.53.0412101439530.6072@bizon.gios.gov.pl>
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

On Fri, Dec 10, 2004 at 02:52:29PM +0100, Krzysztof Oledzki wrote:

> No, REJECT does not DROP. It sends back an error packet in response. So it
> sends response to broken packets.

Yes, but if REJECT can't REJECT it, it very well better DROP instead. 
Would you rather it ACCEPT it?

> Oh, but what if protocol filed is broken? With one bit error we can
> accidently match for example igmp packets with -p tcp.

"tcp", "udp", "igmp", etc., are in the IP header, which better be checked
by that point as well.  That is what I'm saying in my previous message. 
"-p tcp" by itself is matching in only the IP header, which has a
separate checksum.

> Not only for logging. You can use this to protect some hosts with
> broken IP stack like for example unpatched Win95/98, etc.

I'm not against a feature to actually match broken packets in any way. 
I'm just saying that not checking the checksum and skipping such packets
with the rule "-p tcp --dport 80" is wrong.

> So maybe broken packets should go a to different table (broken) and not
> traversal other tables and conntrack? Or any other smart solution.

Possibly.  The kernel would need to know all protocols in order to be
able to filter them before any other rules, though.

Let me make this very clear.  I am talking only about the bad checksum
case, and not about strange or "unclean" packets in any other way.

Would you ever really ever want to accept a packet with a corrupted
checksum?  Would it ever be useful?

Ideally, "-p tcp" could check just the checksums up to the IP level and
NOT the tcp checksum.  "-p tcp" with any other TCP-specific option would
then check the TCP checksum.

So, we could have an example ruleset like this that should work as
expected:

iptables -A FORWARD -d windows_box -m broken --broken-win -J DROP
iptables -A FORWARD -m unclean --some-unclean -m limit ... -J LOG
iptables -A FORWARD -p tcp --dport 80 -J ACCEPT
iptables -A FORWARD -p tcp -j REJECT --reject-with tcp-reset

The above rules would protect the Windows box, log corrupted packets,
accept TCP port 80 packets that don't have a corrupted TCP checksum,
REJECT any other valid TCP packet with a TCP RST, DROP invalid TCP
packets, and follow the policy for the rest.  Simple.

Simon-
