From: Zheng Da <zhengda1936@gmail.com>
Subject: Re: The module I write seems to have conflict with iptables
Date: Mon, 30 Jul 2007 21:49:06 +0200
Message-ID: <46AE40B2.4@gmail.com>
References: <46ACC923.6050600@gmail.com>
	<Pine.LNX.4.64.0707281934120.15125@fbirervta.pbzchgretzou.qr>
	<46ACEC5A.6040103@gmail.com>
	<Pine.LNX.4.64.0707291042080.9488@fbirervta.pbzchgretzou.qr>
	<46ADDA66.3030207@gmail.com>
	<Pine.LNX.4.64.0707291508260.9488@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707291508260.9488@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jul 30 2007 14:32, Zheng Da wrote:
>   
>> I finally find the problem. The problem is not caused by my module, but
>> my configuration of iptables.
>> The original configuration is:
>> iptables -F
>> iptables -X
>> iptables -P FORWARD DROP
>> iptables -A FORWARD -i eth1 -j ACCEPT                        
>> <------------------change this line
>> iptables -A FORWARD -i eth0 -m state --state ESTABLISHED -j ACCEPT
>> iptables -A FORWARD -i eth0 -p tcp --dport 22 -m state --state
>> ESTABLISHED,NEW -j ACCEPT
>>     
>
>   
>> If I change the line for the device of eth1 to
>>
>> 	iptables -A FORWARD -i eth1 -j ACCEPT -m state --state
>> 	ESTABLISHED,RELATED,NEW
>>
>> It works.
>> The problem is what is the difference between
>> 	iptables -A FORWARD -i eth1 -j ACCEPT
>> and
>> 	iptables -A FORWARD -i eth1 -j ACCEPT -m state --state
>> 	ESTABLISHED,RELATED,NEW.
>>     
>
> The first one accepts all packets from eth1, the second only
> EST,REL,NEW -- which excludes INVALID.
>
> INVALID connections do not show up in ip_conntrack I believe, but you can
> make them visible using LOG for example:
>
> 	-i eth1 -m conntrack --ctstate INVALID -j LOG
>   
But it doesn't explain why the change of the configuration can make my 
module work correctly.
I think there should be more difference
>   
>> I check ip_conntrack in Router, the connections between Client and Server
>> are assured in both configurations.
>> I use Wireshark to capture the packets when in the original
>> configuration. I put the result in the attachment.
>> externel: the packets between Client and Router
>> internal: the packets between Router and Server
>>     
>
>   
>> Does anyone have any idea?
>>     
>
> Post to the mailing list, there are more people to answer.
>
>
>
> 	Jan
>   
