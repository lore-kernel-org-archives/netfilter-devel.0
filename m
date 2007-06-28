From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070625
Date: Thu, 28 Jun 2007 21:33:17 +0200
Message-ID: <46840CFD.5060706@trash.net>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
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
> On Jun 28 2007 21:27, Patrick McHardy wrote:
> 
>>I though you would store the struct xt_connlimit_conn in the
>>ct_extend area.
> 
> 
> Ah, that was the big hint. Thank you.
> I'll just put the pointer to xt_connlimit_data there. Just as easy.
> 
> 
>>The only reason I can think of why you'd need
>>the xt_connlimit_data is for the lock. So you could make the
>>lock global (which I think is fine) or add a pointer to the
>>data you need.
> 
> 
> I'd hate to introduce such a lock, because it would make the _whole_ match
> "singleprocessor-sticky".


Use a rwlock or something lockless if you're worried about that.
But that seems like a premature optimization, the time a single
match needs should be very small anyway so its unlikely that
we'll see contention.
