From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 1/2] libnfnetlink, iface conversion to string
Date: Wed, 24 Jan 2007 17:50:08 +0100
Message-ID: <45B78E40.6070707@trash.net>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
	<20070109115120.GX7655@prithivi.gnumonks.org>
	<1169162676.8926.14.camel@localhost>
	<1169163050.8926.16.camel@localhost>
	<45B0E24A.7040906@trash.net> <45B10222.1040806@netfilter.org>
	<20070122123618.GM9631@prithivi.gnumonks.org>
	<59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <59155.90.13.189.211.1169586830.squirrel@mail.inl.fr>
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

Eric Leblond wrote:
> Hi,
> 
> 
>>On Fri, Jan 19, 2007 at 06:38:42PM +0100, Pablo Neira Ayuso wrote:
>>
>>>Patrick McHardy wrote:
>>>Indeed. Eric, all this global stuff below must dissapear at all, from
>>>rtnl.c:
> 
> 
> I've done a big cleaning and I hope I will not annoy Patrick with my
> coding style problem this time.

Thanks Eric, no further objections from my side. Pablo is more familiar
with this code than myself, so I'll leave it to him to apply it.
