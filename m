From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [ANNOUNCE] Release of libnfnetlink, libnfnetlink_conntrack and
 conntrack
Date: Mon, 17 Oct 2005 01:20:08 +0200
Message-ID: <4352E028.7020702@eurodev.net>
References: <20050924215413.GD731@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.62.0510141219460.3698@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.62.0510141219460.3698@bizon.gios.gov.pl>
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
> What such errors mean?
> 
> nfnl_parse_attr: deficit (4) len (43200).
> 
> nfnl_parse_attr: deficit (2) len (35072).

This is due to a wrong calculation of the minimum message size. It is
fixed in SVN.

--
Pablo
