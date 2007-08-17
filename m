From: Amin Azez <azez@ufomechanic.net>
Subject: Re: revisit: ipset nethash set type limited to /31
Date: Fri, 17 Aug 2007 16:18:06 +0100
Message-ID: <46C5BC2E.6020301@ufomechanic.net>
References: <1187333670.3949.81.camel@delta.sgr-a.net>	<Pine.LNX.4.64.0708171303310.5492@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708171458350.9997@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	"Neville C. Dempsey" <NevilleD.Netfilter@sgr-a.net>,
	netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708171458350.9997@bizon.gios.gov.pl>
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

* Krzysztof Oledzki wrote, On 17/08/07 14:03:
> 
> 
> On Fri, 17 Aug 2007, Jan Engelhardt wrote:
> 
>>
>> On Aug 17 2007 16:54, Neville C. Dempsey wrote:
>>>
>>> As ipset_nethash.c stands it handles subnet masks from /1 to /31 fine,
>>> but the cases /0 & /32 are required to be handled in a different chain.
>>
>> /0 is not a network anymore, it is "everything".
>> /32 is a single host, I think iphash is better suited for this.
> As long you don't need to handle both networks and host in the same set.
> If you do then you end up with double number of sets (eg. 400 instead of
> 200) and more complicated iptables rules.
> 
> Best regards,


I think we could have an extra byte per 8 entries, and they can take 1
bit each, giving 33 bit hash entries.

Its the sanest way.

the /0 entry can just be a single flag per hash, as there is only one of
them.

Sam
