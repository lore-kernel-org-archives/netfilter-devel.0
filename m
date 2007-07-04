From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: netfilter queue not on filter table
Date: Wed, 04 Jul 2007 12:07:55 +0900 (JST)
Message-ID: <200707040307.l6437uAL015080@toshiba.co.jp>
References: <717e7cba0707030739h48ce146es8a0e67744af3f790@mail.gmail.com>
	<717e7cba0707030814h2de28c4fx8b672b518a9c008d@mail.gmail.com>
	<717e7cba0707030818m2e646709wea0e8a5306904f79@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: viraptor@gmail.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <717e7cba0707030818m2e646709wea0e8a5306904f79@mail.gmail.com>
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


From: "Stanis=B3aw Pitucha" <viraptor@gmail.com>
Date: Tue, 3 Jul 2007 16:18:56 +0100

> I made a mistake before:
> > - QUEUE target works as expected on filter/INPUT, but I don't catch=

> > any packets if I try to set it up in nat/PREROUTING or
> > mangle/PREROUTING. What can be the cause?

Only the initial packets of connection see rules in PREROUTING in nat t=
able.

> I see incoming messages in mangle/PREROUTING, but not outgoing ones.
> OTOH they are shown in wireshark at the same time, and are sent.

If you mean that 'outgoing ones' are the packets generated at the local=

node queueing packets, they don't pass through PREROUTING, but OUTPUT.

Please refer following.

http://www.netfilter.org/documentation/HOWTO//netfilter-hacking-HOWTO-3=
.html
http://iptables-tutorial.frozentux.net/iptables-tutorial.html#TRAVERSIN=
GOFTABLES

-- Yasuyuki Kozakai
