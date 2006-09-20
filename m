From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 27/39]: PPTP conntrack: get rid of unnecessary byte
 order conversions
Date: Wed, 20 Sep 2006 13:50:02 +0200
Message-ID: <45112AEA.8060300@trash.net>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>	<20060920082517.14636.25440.sendpatchset@localhost.localdomain>
	<200609201146.k8KBkUZ6004236@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jones Desougi <jones@ingate.com>
In-Reply-To: <200609201146.k8KBkUZ6004236@usagi.ingate.se>
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

Jones Desougi wrote:
>>--- a/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
>>+++ b/include/linux/netfilter_ipv4/ip_conntrack_pptp.h
>>@@ -31,8 +31,8 @@ struct ip_ct_pptp_master {
> 
> ...
> 
>>-	u_int16_t pac_call_id;			/* call id of PAC, host byte order */
>>-	u_int16_t pns_call_id;			/* call id of PNS, host byte order */
>>+	__be16 pac_call_id;			/* call id of PAC, host byte order */
>>+	__be16 pns_call_id;			/* call id of PNS, host byte order */
> 
> 
> Uhm, how about updating the comments here? :-)


Yes, I missed those. I'll fix them in the next batch, I'm not completely
done with PPTP yet.
