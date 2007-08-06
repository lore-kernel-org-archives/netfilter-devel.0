From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_policy: output policy not valid in PRE_ROUTING and INPUT
Date: Mon, 06 Aug 2007 14:44:11 +0200
Message-ID: <46B7179B.7090002@trash.net>
References: <Pine.LNX.4.64.0708061317410.23493@bizon.gios.gov.pl>
	<46B7145B.4070407@trash.net>
	<Pine.LNX.4.64.0708061438011.23493@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708061438011.23493@bizon.gios.gov.pl>
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
> On Mon, 6 Aug 2007, Patrick McHardy wrote:
> 
>> The IPsec policy is selected after routing, which is why can't
>> be used in PREROUTING.
> 
> 
> Is there any other solution than duplicating ipsec policies with "-A
> PREROUTING -s (...) -d (...) -p (...) -j RETURN"? I would like to
> REDIRECT only packets that are not going thru ipsec tunnels.


I can't think of one.
