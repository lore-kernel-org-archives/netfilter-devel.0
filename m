From: "Qiang" <qzhang@endeavorsystems.net>
Subject: RE: Changing packet data {Virus Scanned}
Date: Mon, 19 Apr 2004 10:19:31 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200404191423.i3JENZFq003381@localhost.localdomain>
References: <20040417123252.GA22087@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "=?iso-8859-2?Q?'Piotr_Gasid=B3o'?=" <quaker@pandora.barbara.eu.org>,
   <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040417123252.GA22087@pandora.barbara.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Piotr,

I found it is do-able in MATCH if you are not enlarging the packet, if
resizing it to larger packet, you probably have to swap it to a new SKB
buffer, which is not do-able from MATCH, can only be done via TARGET

Q

-----Original Message-----
From: netfilter-devel-admin@lists.netfilter.org
[mailto:netfilter-devel-admin@lists.netfilter.org] On Behalf Of Piotr
Gasidlo
Sent: Saturday, April 17, 2004 8:33 AM
To: netfilter-devel@lists.netfilter.org
Subject: Changing packet data {Virus Scanned}

Hello,

I'm trying to develop match which is able to change packet data
according to perl regular expression, s/.../.../. Finding match is very
easy. But I'm stuck in replacing it. One thing that bothers me it's how
to resize packet (replacement can be shorter or taller than match) in
match() function. I'm only beginner in <skbuff.h> functions, which =
should
I use? And whether this is possible to do it in match (not in TARGET).

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again
