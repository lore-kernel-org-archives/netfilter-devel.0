From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: Thu, 02 Sep 2004 14:39:03 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094128743.2816.36.camel@nienna.balabit>
References: <1092407190.2402.120.camel@nienna.balabit>
	<20040902051011.GA1453@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	jamal <hadi@cyberus.ca>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040902051011.GA1453@alpha.home.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-09-02, cs keltez=E9ssel 07:10-kor Willy Tarreau ezt =EDrta:
> >	One more
> >         example could be TCP window tracking, I don't think we have
> >         the necessary bandwidth and CPU time to send an update messag=
e
> >         after each and every received TCP packet... Any idea how we
> >         could solve these problems?
>=20
> I don't really agree on the bandwidth argument : a small TCP packet wit=
h
> only an ACK or a control flag is 40 bytes. This is 12 bytes more than t=
he
> smallest UDP packet, so if you can update a connection with at most 12 =
bytes,
> you can use links of the same nature. BTW, I don't think you should sen=
d one
> packet per connection. You should queue updates into a list, and build =
the
> update packet from this list. This way, you eliminate the IP+UDP header=
 (28
> bytes) for all updates except the first one, which means you then have =
40
> bytes to update a connection without using more bandwidth. I'm not sayi=
ng
> this is much enough for every case, but I think that depending on the t=
ype
> of message (creation, update, destruction), we might do things with thi=
s.

  We already have such a queuing facility, a packet is sent only in case
of timeout (2s) or if it is full. The problem is the size of the
messages. At the moment, ct_sync always sends completely self-contained
updates: that is, a single update message contains every bit of
information about a conntrack entry. Because of this, the size of an
update message is 240 bytes (+ 4 byte for the message header). Because
of this, you can have about five update messages per packet, which is
not too much... (There are plans to implement a more fine-grained update
mechanism, but I don't know who will have the time to implement that.)

> If you don't want to synchronize TCP windows, you might also turn the s=
lave
> in a "lazy mode" for existing connections when it becomes master. This =
is a
> bit dirty, but might be an acceptable trade-off.

  Yes, this is exactly what Jozsef suggested.

--=20
 Regards,
   Krisztian KOVACS
