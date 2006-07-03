From: Patrick McHardy <kaber@trash.net>
Subject: Re: conntrack table filling up due to missing ACKs near the end of
 a TCP session
Date: Mon, 03 Jul 2006 20:19:34 +0200
Message-ID: <44A95FB6.8050007@trash.net>
References: <44A53301.1090603@netboxblue.com> <44A53AD7.9000007@trash.net>
	<44A94ED1.2030204@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Menno Smits <menno@netboxblue.com>
In-Reply-To: <44A94ED1.2030204@netboxblue.com>
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
> I tried enabling invalid packet logging like you suggested but nothing
> was logged.

Forgot to mention, you need to have one of ipt_LOG or ipt_ULOG loaded,
in case of ipt_ULOG you also need the ulog daemon running.

> Turning off connection pickup via ip_conntrack_tcp_loose fixes the
> problem. There definitely seems to be an issue with packets being
> associated with the wrong connection.
> 
> I've looked a little closer at the dodgy connections in the table
> (before the workaround). They are always of one of two forms, 2 packets
> sent or 3 packets sent:
> 
> tcp      6 51949 ESTABLISHED src=pri.ma.ry.ip dst=sec.ond.ary.ip
> sport=25 dport=38755 packets=3 bytes=183 [UNREPLIED] src=sec.ond.ary.ip
> dst=pri.ma.ry.ip sport=38755 dport=25 packets=0 bytes=0 mark=0 use=1
> 
> tcp      6 48900 ESTABLISHED src=pri.ma.ry.ip dst=sec.ond.ary.ip
> sport=25 dport=57868 packets=2 bytes=122 [UNREPLIED] src=sec.ond.ary.ip
> dst=pri.ma.ry.ip sport=57868 dport=25 packets=0 bytes=0 mark=0 use=1
> 
> The IPs, packet counts and byte counts are always identical. Only the
> non-port-25 ports change.
> 
> Are you interested in packet dumps of the connections that cause this
> behaviour? I have some here.

Yes, that might give some clues. Just send it to me in private or
on-list, as you like.
