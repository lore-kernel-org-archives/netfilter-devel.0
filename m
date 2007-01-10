From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Patch 1/2] Resend : sending iface name from nfnetlink_queue
Date: Wed, 10 Jan 2007 07:52:23 +0100
Message-ID: <45A48D27.6070105@trash.net>
References: <1167257854.31765.21.camel@localhost>	
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
	<1167727582.13797.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Vincent Deffontaines <vincent@inl.fr>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eleblond@inl.fr>
In-Reply-To: <1167727582.13797.5.camel@localhost.localdomain>
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
> Le vendredi 29 d=E9cembre 2006 =E0 00:40 +0100, Eric Leblond a =E9crit =
:
>=20
>>>Eric Leblond wrote:
>>>
>>>>I'm currently working on NuFW where I try to do iface conversion from
>>>>integer to string to be able to filter "naturally" on interfaces.
>>>
>>>Interesting question. Since this is related with the rtnetlink
>>>subsystem, I'm unsure that this feature naturally belongs to
>>>libnfnetlink nor to libnetfilter_queue.
>>
>>I've looked at kernel code and the information was easy to add. I attac=
h
>>a small patch against kernel.
>=20
>=20
> I resend a modified version of my kernel patch. It fixes a bug on field=
s
> size.


I think Harald already stated his dislike for this approach, just
to be explicit: I don't think we should add interface names to the
netlink protocols, userspace should resolve the ifindex.
