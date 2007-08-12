From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT 20070806
Date: Mon, 13 Aug 2007 00:23:44 +0200
Message-ID: <46BF8870.6040309@trash.net>
References: <Pine.LNX.4.64.0708061455480.13469@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708121330370.28963@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708121330370.28963@fbirervta.pbzchgretzou.qr>
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
> On Aug 6 2007 15:06, Jan Engelhardt wrote:
> 
>>Subject: xt_TARPIT 20070806
> 
> 
> I'd like to get some comments if possible.
> Otherwise I assume it's ready to be included ;-)


I'm not queueing patches for 2.6.24 until the current regressions
are fixed, unfortunately I'm a bit short on time myself. I you
want to help accelerate this, the mark_source_chains regression
reported by Thomas Jarosch is currently most important, and its
a nice opportunity for anyone interested to dive into the uglies
of ip_tables :)
