From: Pablo Neira <pablo@netfilter.org>
Subject: conntrack display problem [Was Re: [ANNOUNCE] Release of
 libnfnetlink, libnfnetlink_conntrack and conntrack]
Date: Wed, 05 Oct 2005 18:39:24 +0200
Message-ID: <434401BC.6000806@netfilter.org>
References: <20050924215413.GD731@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.62.0509291021170.31974@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0509291021170.31974@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> It seems that conntrack is not able to display properly counters for 
> incoming packets:
> 
> # conntrack -L
> tcp      6 431999 ESTABLISHED src=192.168.0.33 dst=192.168.11.74 
> sport=33328 dport=22 packets=2025 bytes=292027 src=192.168.11.74 
> dst=192.168.0.33 sport=22 dport=33328 packets=0 bytes=0 [ASSURED] mark=0 
> use=1 id=42
> 
> # cat /proc/net/ip_conntrack
> tcp      6 431999 ESTABLISHED src=192.168.0.33 dst=192.168.11.74 
> sport=33328 dport=22 packets=3106 bytes=218222 src=192.168.11.74 
> dst=192.168.0.33 sport=22 dport=33328 packets=2015 bytes=290691 
> [ASSURED] mark=0 use=1

Already fixed, please check SVN.

> BTW: Is it possible to use "id" to delete a conntrack?

Not yet but it will be soon. Then it could be possible to use the id 
together with one of the tuples (original or reply) to kill conntracks.

--
Pablo
