From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/11] Remove ASSERT_{READ,WRITE}_LOCK
Date: Fri, 03 Nov 2006 13:42:50 +0100
Message-ID: <454B394A.2000602@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210914.306515682@wlug.westbo.se>
	<454B3532.9090701@trash.net>
	<Pine.LNX.4.58.0611031329570.2974@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <Pine.LNX.4.58.0611031329570.2974@tux.rsn.bth.se>
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

Martin Josefsson wrote:
> On Fri, 3 Nov 2006, Patrick McHardy wrote:
> =C2=B4
>>BTW, the patch doesn't touch any x_tables files, did you forgot
>>to commit them?
>=20
>=20
> I forgot to change the description when I ported the patch to a newer
> kernel where I think x_tables already had them removed. (my laptop with
> the kernel trees is suspended at home right now)

Turns out x_tables doesn't have any :) But I killed off the remaining
ones.
