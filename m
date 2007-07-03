From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Tue, 03 Jul 2007 13:08:33 +0200
Message-ID: <468A2E31.7050809@trash.net>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<4688FC41.5070403@trash.net>
	<Pine.LNX.4.64.0707022005200.25153@bizon.gios.gov.pl>
	<468941D6.7090306@trash.net>
	<Pine.LNX.4.64.0707022106250.25153@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707022106250.25153@bizon.gios.gov.pl>
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
>>
>> You can drop in PREROUTING/mangle for example. In the filter table
>> its not possible of course since there is no PREROUTING chain :)
> 
> 
> Indeed, but I found dropping in filter more useful. That's why I mention
> about my patched kernel. BTW: is there any reason why it is not
> available by default?


You mean PREROUTING/filter? Mainly performance, new hooks are expensive.
