From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7 parse attributes with nfattr_parse in
	nfnetlink_check_attribute
Date: Wed, 14 Mar 2007 09:23:47 +0100
Message-ID: <45F7B113.2080402@trash.net>
References: <45D0EE40.4050404@netfilter.org> <45D19B7A.5080305@trash.net>
	<20070306214527.GD521@postel.suug.ch>
	<45EE9754.8040304@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45EE9754.8040304@netfilter.org>
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
> Thomas Graf wrote:
>=20
>>* Patrick McHardy <kaber@trash.net> 2007-02-13 12:05
>>=C2=B4
>>>Thomas, what do you think of this patch?
>>
>>I believe that all unknown attributes should be ignored so recent
>>userspace code can function on older kernels. That's the way I'm
>>working towards.
>=20
>=20
> Then I'll resend the patch if nobody objects anymore ;)


Don't bother, I've applied the patch you sent. Thanks everybody.
