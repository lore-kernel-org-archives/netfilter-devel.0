From: "miguel Angel Vazquez" <mikinho21@gmail.com>
Subject: Re: development with queues
Date: Thu, 20 Apr 2006 12:55:13 +0200
Message-ID: <f015bcab0604200355jfa0756cya5b8248cf6d712bc@mail.gmail.com>
References: <f015bcab0604180253m76a8d960q5c7b6d821401927e@mail.gmail.com>
	<859616420604180331g5644e343x8dc47d85278a4f62@mail.gmail.com>
	<859616420604180346o2706c306wcf7703dc9b7f67e9@mail.gmail.com>
	<a1f5b31e0604181231x69124db5qd6345d544cea9e44@mail.gmail.com>
	<44475817.70100@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44475817.70100@ufomechanic.net>
Content-Disposition: inline
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

hi mates!

thanks for all your replys. As James and Sam have said it seems to be
not a tribial matter. As Sam have said it is probably more efficient
to use a transparent proxy like squid. Well in fact it was one of my 2
ideas.  And obviously as Sam said using a Squid could bring me some
more advantages. I wll talk to my boos about that option.

I'm going to explain some details about the project, as Sam asked me
to do. our developmeny platform is going to be a Linksys WRT54g3G (or
something like that), operating under Openwrt. The idea was that a
wifi/LAN user could browse the Inet using the UMTS link. Besides there
are some guys working here in MESH networking and authentification...
and more important, research of users' hardware profile.

In fact we wanted to eliminate the headers oh HTTP because we are
going to suppose that we have identified all the users profiles( and
saved in a database owned by a proxy "in the other side of internet")
and we are going to send to that proxy a simply user identifier.

Maybe we are not going to eliminate big quantity of information, but
the UMTS uplink is not quite wide, so it could be interesting.
About the TCP problems...well, we are thinking in that question, and
we are studying what to do: using a modifyed TCP, using other
protocol...

Mike
