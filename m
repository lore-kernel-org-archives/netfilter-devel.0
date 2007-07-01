From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Sun, 1 Jul 2007 15:51:17 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707011550120.15758@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
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


On Jul 1 2007 05:01, Krzysztof Oledzki wrote:
>>
>> > Setting net.ipv4.netfilter.ip_conntrack_tcp_be_liberal solves the problem,
>> > but this is not a right fix and now the main question is: was this ACK
>> > really over the upper bound since when
>> > net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled it is possible to
>> > access this page (of course with many netfilter warnings that "ACK is over
>> > the upper bound").
>
> Found this:
>
> http://groups.google.pl/group/fa.openbsd.tech/browse_frm/thread/e27c7363b2c636b5/01ba6e0fa873cf42
>
> Sounds familiar - it seems that there may be a crappy OpenBSD firewall lurking
> somewhere along the path. :(

Question... does the problem also go away if you leave
net.ipv4.netfilter.ip_conntrack_tcp_be_liberal as previously and instead set
net.ipv4.tcp_sack = 0?


	Jan
-- 
