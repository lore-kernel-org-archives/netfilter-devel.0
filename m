From: Andrew Beverley <andy@andybev.com>
Subject: Re: xt_connlimit 20070620_2
Date: Wed, 20 Jun 2007 18:21:04 +0100
Message-ID: <20070620182104.weg70sp9nkgg08kw@www.simplelists.com>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
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


> I fixed the crash. Sometimes, I should just look at the regs :) EBP was
> totally beyond any reasonable value which directed me to the hash
> function which was missing a "% 256".
>
> Patrick, please merge. (xt_u32 as posted is functional and already
> complete, please merge too.)
> Andrew, please see if this works for you too now.

Thanks Jan. In my very quick initial tests it works now.

Regards,

Andy
