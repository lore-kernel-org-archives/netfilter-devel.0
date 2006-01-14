From: Patrick McHardy <kaber@trash.net>
Subject: Re: new iptables policy match
Date: Sat, 14 Jan 2006 17:22:43 +0100
Message-ID: <43C92553.5010207@trash.net>
References: <925A849792280C4E80C5461017A4B8A26DBB@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Marco Berizzi <pupilla@hotmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
In-Reply-To: <925A849792280C4E80C5461017A4B8A26DBB@mail733.InfraSupportEtc.com>
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

Greg Scott wrote:
>>No, the tunnel endpoints are the hosts using the 
>>tunnel-mode SA, so in this case both firewalls.
> 
> 
> OK, so now I'm confused.  And admittedly, IPSEC has made
> me crazy for several years.  Which NICs on the firewalls
> are the endpoints?  Is this picture better and more accurate?
> 
> 
>   LAN             Internet             LAN
>  <----+--FW---+-------------+--FW---+----->
>       |       |             |       |
> NIC with  NIC with      NIC with  NIC with
> private    public        public   private
>   IP        IP <---------> IP       IP
>                    SA
>           Tunnel          Tunnel
>          endpoint        endpoint
> 
> So the public NICs are the tunnel endpoints?

Yes. Its very simple, the endpoints are the addresses you specify
in the policy in the tunnel section (x.x.x.x and y.y.y.y):

spdadd net/mask net/mask any ipsec out
	tunnel/x.x.x.x-y.y.y.y/require;
