From: mbellion@hipac.org
Subject: Re: [NF-HIPAC] Performance test results available
Date: Thu, 26 Sep 2002 21:17:20 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200209262117.20361.mbellion@hipac.org>
References: <200209260003.10724.nf@hipac.org> <3D92BBBD.1050609@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: "Netfilter-devel" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3D92BBBD.1050609@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

> 1) How does behave the CPU load during your test ?
> As you are using very powerful machines (which is not often the case in
> reality for firewalls and router), I was really wandering how the CPU
> power can affect your method.

Sorry, we don't have information about that available. We will have to do=
=20
additional tests with less powerfull machines to examine that.

> 2) How much space was used to store each of the rulessets ?
> Your representation seems to be compact, but I was wandering how ?
> Maybe a comparison with the size of the iptables rulessets could
> be relevant.

The memory usage of our algorithm isn't that much dependent on the number=
 of=20
rules. It's much more dependent on the structure of the ruleset and the t=
ype=20
of the used rules. It is e.g. possible that a ruleset with 100 rules uses=
=20
more memory than a ruleset with 10.000 rules. There are case where nf-hip=
ac=20
uses less memory than iptables and there are case where nf-hipac consumes=
=20
really a huge amount of memory.
It's not possible to easily describe the memory usage of nf-hipac. It dep=
ends=20
on a lot of factors and interactions of different rule types.
Our algorithm is designed to have an acceptable memory usage for realisti=
c=20
rulesets. In the tests we made we didn't use realistic rulesets, but=20
completely synthetic ones in order to simultate theoretical worst case=20
performance of the algorithm.
We haven't wrote down memory usage during the tests, so we don't have the=
=20
numbers available. But as already said, the rulesets were completely=20
syntetic, so the numbers probably don't say much about the algorithm anyw=
ay.
I only remember that memory usage was pretty huge with that synthetic=20
rulesets.

Michael Bellion
