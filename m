From: knash@cs.tcd.ie
Subject: Forwarding IP broadcasts
Date: Fri, 26 Aug 2005 15:21:40 +0100 (IST)
Message-ID: <2763.134.226.1.62.1125066100.squirrel@webmail.cs.tcd.ie>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,
  Does anyone know how I could forward IP broadcasts?
That is when I receive a unicast/broadcast packet that
is not addressed to the localhost I would like to
change its address to 255.255.255.255 and forward it
on.
I know that the reason linux does not like this, if you
were to ping 255.255.255.255 and nodes forwarded broadcasts
you could be in trouble :-)

Yet in a routing protocol I'm trying to implement, if I don't
know the next hop for a packet I would like to use broadcasts
in a controlled fashion,

So I was wondering do any of you know where broadcasts are
dropped on forwarding and if you know how I could patch the
kernel (or otherwise ) to get around this,

Thanks very much for your time,
Kevin
