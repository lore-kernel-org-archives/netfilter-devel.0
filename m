From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit kernel 20070620
Date: Wed, 20 Jun 2007 14:47:57 +0200
Message-ID: <467921FD.8000909@trash.net>
References: <Pine.LNX.4.64.0706200039290.5731@fbirervta.pbzchgretzou.qr>
	<4678F7A2.6090203@netfilter.org>
	<Pine.LNX.4.64.0706201224490.5731@fbirervta.pbzchgretzou.qr>
	<46790A58.9050106@netfilter.org>
	<Pine.LNX.4.64.0706201328260.5731@fbirervta.pbzchgretzou.qr>
	<46791704.4090609@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46791704.4090609@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
> 
>> UDP does not have a transition from ESTABLISHED -> TIME_WAIT, to begin
>> with.
> 
> 
> But the event API has the DESTROY transition. There are three kind of
> events: NEW, UPDATE and DESTROY. Just wait for DESTROY events to release
> the entry from the hashtable.


Thats not a bad idea, but I always considered the notifier chains
overkill just for ctnetlink and thought about replacing them by
simple hooks. Adding another user for them would need some good
justification, also since it quite heavily adds to the overhead
for packet processing.
