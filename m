From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ulogd fix for kernel 64bits/userspace 32bits system
Date: Thu, 12 Oct 2006 16:26:49 +0200
Message-ID: <452E50A9.4050809@trash.net>
References: <1160654607.9238.5.camel@localhost.localdomain>		<452E30AE.9030805@trash.net>	<1160662471.15687.11.camel@localhost.localdomain>
	<452E4FEF.1080100@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <452E4FEF.1080100@trash.net>
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

Patrick McHardy wrote:
> Eric Leblond wrote:
>=20
>>Le jeudi 12 octobre 2006 =E0 14:10 +0200, Patrick McHardy a =E9crit :
>>
>>
>>>- its a compile-time solution and therefor unusable for distributors
>>>
>>>- it might get accidentally enabled by a distributor should he
>>> be crazy enough to compile packages in a mixed environment
>>
>>
>>Both points seem linked with autodetection of system. I agree that it i=
s
>>potentially dangerous.
>>
>>In fact, it may be better to use a configure flag approach ? What do yo=
u
>>think ?
>=20
>=20
> That sounds better - ideally with a big warning that states
> that it is just a workaround and _will_ break in case real
> compatibility is introduced to the kernel.

BTW, maybe its even possible to do runtime detection? That
would also fix the first issue.
