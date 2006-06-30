From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack table filling up due to missing ACKs near the end of
 a TCP session
Date: Fri, 30 Jun 2006 16:53:11 +0200
Message-ID: <44A53AD7.9000007@trash.net>
References: <44A53301.1090603@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
In-Reply-To: <44A53301.1090603@netboxblue.com>
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

Menno Smits wrote:
> Hi all,
> 
> I'm seeing a problem on a customer box that acts as a primary MX and is
>  running netfilter. The secondary MXs (run by the ISP) appear to be
> broken and cause the conntrack table on the primary MX to fill up.
> 
> What happens is this:
> 
> - secondary connects to deliver mail
> - connection is established and SMTP conversation takes place
> - secondary issues QUIT
> - primary sends response "221 Bye"
> - primary sends FIN
> - secondary sends FIN
> - primary ACKs FIN from secondary
> 
> The secondary never ACKs the last data packet ("221 Bye") or FIN sent by
> the primary. Later the primary retries the "221 Bye" packets several
> times. Interestingly the secondary also sends a Keep-Alive soon after it
> sends it's FIN.
> 
> This happens for every inbound connection from the secondaries and the
> result is 1000's of ESTABLISHED entries with 5 day timeouts in the
> conntrack table. The table eventually fills up causing packet loss. The
> conntrack entries are all of the form:
> 
> tcp      6 24826 ESTABLISHED src=pri.ma.ry.ip dst=sec.ond.ary.ip
> sport=25 dport=54334 packets=3 bytes=183 [UNREPLIED] src=sec.ond.ary.ip
> dst=pri.ma.ry.ip sport=54334 dport=25 packets=0 bytes=0 mark=0 use=1
> 
> The primary is blocking packets that aren't NEW, ESTALISHED or RELATED.
> This could be contributing to the problem but I haven't looked closely
> at this.

If you look at the byte counters, the connection seems to consist
only of three packets sent by the primary. I guess one of them
was an ACK, which through connection pick-up places the conntrack
in ESTABLISHED state. The first question would be why they're not
properly associated with the real connection. Please try
"echo 255 > /proc/net/ipv4/netfilter/ip_conntrack_log_invalid".
As a work-around you could disable connection pickup or drop
outgoing TCP packets with state NEW but no SYN.
