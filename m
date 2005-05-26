From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: [PATCH] bring ct_sync up-to-date with 2.4.30
Date: Thu, 26 May 2005 15:27:32 +0200
Message-ID: <1117114052.4551.12.camel@nienna.balabit>
References: <1116877042.1848.9.camel@xbox>
	<1117109883.4551.4.camel@nienna.balabit>
	<9151ac2a05052606041b4e6bfb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <9151ac2a05052606041b4e6bfb@mail.gmail.com>
To: Filip Sneppe <filip.sneppe@gmail.com>
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


  Hi,

2005-05-26, cs keltez=E9ssel 15.04-kor Filip Sneppe ezt =EDrta:
> OK, I only found out about 2.6 support yesterday when going through=
 the=20
> netfilter-failover list archives (I now realize I should have sent =
the patch to
> this list too), but will give it a try asap.

  Thanks, and please report your experiences either to me or on the
list.

> Two small questions though:
> - Are there currently major differences between 2.4 and 2.6 ct_sync=
 ?

  Yes, there are, although these are mostly internal changes.
Unfortunately the differences are large enough to make maintaining bo=
th
versions concurrently a major pain so we decided to drop the 2.4
support.

> - Is the TODO issue about conntrack/nat helpers and expected connec=
tions
>   and ct_sync currently blocked because noone knows how to solve th=
e
>   problem yet, or do you know how to tackle the problem, but haven'=
t found the
>   time to write the code yet ?

  There were some problems with expectation handling up to 2.6.10.
However, in Linux 2.6.11 this has been simplified a lot, and this mak=
es
implementing expectation failover much easier. Unfortunately I curren=
tly
lack the necessary hardware and free time, and although Harald has be=
en
working on the project lately, things are moving painfully slowly...

  So, any help with the project (testing, hunting bugs or contributin=
g
source code) is much appreciated. Feel free to email me/the list if y=
ou
have any questions.

  BTW, the ct_sync for 2.6.11 is not in the SVN tree yet, there's a
patch on my snapshots page, or you can find it in broken-out form in =
my
GNU Arch repository at

http://people.netfilter.org/hidden/archives/2005-public/

--=20
KOVACS Krisztian <hidden@sch.bme.hu>
