From: Menno Smits <menno@netboxblue.com>
Subject: Re: "Late REDIRECT"
Date: Tue, 14 Mar 2006 12:50:32 +1000
Message-ID: <44162F78.50203@netboxblue.com>
References: <44153615.50408@netboxblue.com> <441550F6.7060609@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <441550F6.7060609@eurodev.net>
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

Hi Pablo,

Pablo Neira Ayuso wrote:
>>
>> Is something like this feasible? How difficult would it be implement? Am
>> I barking up the wrong tree?
> 
> Ick, this seems frigthening. Why don't you filter in the raw PREROUTING?

Two reasons:

1) You can't do REJECT in raw, only DROP.

2) You still need to use convoluted rules to figure out where packets 
are going to go. In the filter table you know what's being forwarded and 
what is local and in filter FORWARD you know both the source and 
destination interface. Currently we use an intricate arrangement of 
chains and rules in mangle PREROUTING to determine the marks to set 
based on the known IPs, networks and routes for each interface. Packets 
then get handled according to their marks in the filter and nat tables.

Regards,
Menno



Scanned by the NetBox from NetBox Blue
(http://netboxblue.com/)
