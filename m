From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_connlimit 20070628
Date: Thu, 28 Jun 2007 21:51:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468410A9.70309@trash.net>
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

>Jan Engelhardt wrote:
>> On Jun 28 2007 21:27, Patrick McHardy wrote:
>> 
>>>I though you would store the struct xt_connlimit_conn in the
>>>ct_extend area.
>> 
>> 
>> Ah, that was the big hint. Thank you.
>> I'll just put the pointer to xt_connlimit_data there. Just as easy.
>
>Actually my entire suggestion may be broken. We can't
>allocate extensions once the conntrack is confirmed.
>So this would only work for new connections.

Yes. And the actual connlimit rule may be inserted after the connection 
is already past --ctstate NEW.
So I submit today's xt_connlimit (with IPv6 yay!!)


	Jan
-- 
