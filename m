From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Fri, 15 Jun 2007 18:15:50 +0200
Message-ID: <4672BB36.2030605@trash.net>
References: <Pine.LNX.4.61.0706051317150.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051317440.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706051406570.20829@yvahk01.tjqt.qr>
	<46657E13.50106@trash.net> <46727873.20503@ufomechanic.net>
	<Pine.LNX.4.64.0706151810260.32724@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706151810260.32724@fbirervta.pbzchgretzou.qr>
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
> On Jun 15 2007 12:30, Amin Azez wrote:
> 
>>>and the neighbour table family is always AF_INET since the
>>>match is only registered for AF_INET.
>>>  
>>
>>Maybe if I take out these checks, I should restrict the match to FORWARD
>>and POSTROUTING?
> 
> 
> Leaving them in does not cost too much.


Thats no reason to keep pointless checks around.
