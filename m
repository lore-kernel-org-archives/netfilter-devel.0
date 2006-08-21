From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3][CONNTRACK] Introduce the pickup facilities to take
 over TCP connections
Date: Mon, 21 Aug 2006 22:04:17 +0200
Message-ID: <44EA11C1.2090705@netfilter.org>
References: <44E972E1.4080500@netfilter.org>
	<Pine.LNX.4.64.0608211214120.25230@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0608211214120.25230@bizon.gios.gov.pl>
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
> 
> On Mon, 21 Aug 2006, Pablo Neira Ayuso wrote:
> 
>> This patch introduces a new flag called IPS_PICKUP that forces the 
>> protocol handler to pick up the window of valid TCP packets. Moreover, 
>> four new attributes to inject the window scale factor and enable SACK 
>> are introduced.
>>
>> These new facilities provide the appropiate mechanisms to take over 
>> TCP connections in failover settings with TCP tracking enabled.
>>
> Are there any plans for active-active synchronization? This requires 
> online TCP SEQ sync or to keep connections in IPS_PICKUP state forever, 
> doesn't it?

Hm, you mean the active-active setting for conntrackd? The current 
architecture already supports it.

You seem to be confused with the IPS_PICKUP flag: this flag must be set 
for conntracks created from userspace via ctnetlink, thus the TCP window 
tracking knows that it has to take over the valid window of TCP 
sequences, once that happens this flag is unset.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
