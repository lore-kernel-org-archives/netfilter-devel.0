From: Patrick McHardy <kaber@trash.net>
Subject: Re: 'recent' matching when less than hitcount hits
Date: Fri, 29 Jun 2007 14:23:35 +0200
Message-ID: <4684F9C7.4080603@trash.net>
References: <20070627090043.GC31525@sliderule.msquared.com.au>
	<20070627094145.GB4288764@metu.edu.tr>
	<20070627090043.GC31525@sliderule.msquared.com.au>
	<468228DA.2040809@trash.net>
	<20070628040348.GD31525@sliderule.msquared.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: hdemir@metu.edu.tr,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
To: Msquared <1.list.netfilter@msquared.id.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070628040348.GD31525@sliderule.msquared.com.au>
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

Msquared wrote:
> On Wed, Jun 27, 2007 at 11:07:38AM +0200, Patrick McHardy wrote:
> 
> 
>>>I seem to be having a problem where a rule with --hitcount is matching
>>>when there are fewer hits than is listed in the hitcount parameter.
>>
>>Which kernel version are you using?
> 
> 
> 2.4.22-1.2199.8.legacy.nptl
> 
> 
> On Wed, Jun 27, 2007 at 12:41:46PM +0300, hdemir@metu.edu.tr wrote:
> 
> 
>>>The rules are in a chain that is only hit for incoming SSH connections.
>>>EG: I have this rule in the INPUT chain:
>>>
>>>  -m tcp --dport 22 -j service-ssh
>>
>>You are sending all the traffic to the port 22. Use -m state --state
>>NEW, so that only new ssh connections can be updated. 
> 
> 
> I already tried that, but it made no difference (perhaps because -m state
> --state ESTABLISHED,RELATED -j ACCEPT higher in the INPUT chain).
> 
> Note from the iptables -vnL output that I showed that it only counted one
> hit on the --set rule and a number of hits on the --update rule.


I think I know what the reason is. My rewritten version of the recent
match matches if the current packet is the nth hit and in that case
doesn't note the entry. So you're only seeing n-1 entries in /proc.

Did the old version behave differently here?
