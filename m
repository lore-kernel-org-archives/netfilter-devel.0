From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: H.323 behavior
Date: Thu, 31 May 2007 00:23:03 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A210B7FC@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Jing Min Zhao <zhaojingmin@users.sourceforge.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

I'll be happy to test it...

- Greg
=20

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Wednesday, May 30, 2007 11:35 PM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org; Jing Min Zhao
Subject: Re: H.323 behavior

Greg Scott wrote:
> Apologies - I never replied back to the list on how this turned out.
> Jing Min Zhao was kind enough to reply privately and we developed a=20
> theory. Jing was right.  The problem was, I had set up the Polycom=20
> codec here to use fixed ports - a legacy from before Jing's H.323=20
> module.  So every time I hung up a call and tried again, the Polycom=20
> would try to call using the same ports.  But the firewall hadn't=20
> cleared them yet and that's why the strange behavior.  The cure - just

> get rid of fixed ports on the Polycom codec and use it as delivered
from the factory.


It would probably make sense to destroy the connection when we seen a
CloseLogicalChannel or CloseLogicalChannelAck message to deal with this
kind of problem.
