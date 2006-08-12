From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Trivial replace of ip_queue by
 nfnetlink_queue	in	nfnetlink_queue code
Date: Sat, 12 Aug 2006 17:31:05 +0200
Message-ID: <44DDF439.30104@trash.net>
References: <1155394240.10172.29.camel@localhost>	 <44DDEFF2.9010403@trash.net>
	<1155396101.10172.36.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1155396101.10172.36.camel@localhost>
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
> Le samedi 12 ao=FBt 2006 =E0 17:12 +0200, Patrick McHardy a =E9crit :
>=20
>>But I think it
>>would make more sense to throw most of these printks out.
>=20
>=20
> The one about queue full is really useful to notice performance issue o=
r
> problems.

Yes, but we already have counters for that and dropped packets are not
too uncommon, we shouldn't flood the ringbuffer with this.

> By the way, do you have a public git tree where we could fetch the
> latest version of the code ?=20

No, but it only includes very few patches currently anyway. I plan
to merge the priv_data stuff this weekend and push my queued patches
for 2.6.19 to Dave, so people can work off his tree.
