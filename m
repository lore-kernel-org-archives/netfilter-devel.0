From: Jones Desougi <jones@ingate.com>
Subject: Re: [NETFILTER 27/39]: PPTP conntrack: get rid of unnecessary byte
	order conversions
Date: Wed, 20 Sep 2006 13:46:30 +0200
Message-ID: <200609201146.k8KBkUZ6004236@usagi.ingate.se>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
	<20060920082517.14636.25440.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-reply-to: <20060920082517.14636.25440.sendpatchset@localhost.localdomain>
	(message from Patrick McHardy on Wed, 20 Sep 2006 10:24:26 +0200
	(MEST))
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


> --- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
> +++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
> @@ -31,8 +31,8 @@ struct ip_ct_pptp_master {
...
> -	u_int16_t pac_call_id;			/* call id of PAC, host byte order */
> -	u_int16_t pns_call_id;			/* call id of PNS, host byte order */
> +	__be16 pac_call_id;			/* call id of PAC, host byte order */
> +	__be16 pns_call_id;			/* call id of PNS, host byte order */

Uhm, how about updating the comments here? :-)

    /Jones
