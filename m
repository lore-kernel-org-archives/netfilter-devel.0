From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: The big Picture of all the tables ...
Date: Sat, 04 Jun 2005 20:50:32 +0000
Message-ID: <42A21418.7030008@outerspace.dyndns.org>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert de Bath <list-netfilter@debath.co.uk>
In-Reply-To: <3abe8064b60ddf1a@mayday.cix.co.uk>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Robert de Bath on 2005-06-04 18:10 UTC:

> I _think_ the attached picture shows all the predefined chains in all
> the tables that the kernel uses in the order that it uses them (except
> for the raw table).
> 
> 1) Is anything wrong?
> 2) Where does the raw table fit?
> 3) What happens if you use NOTRACK.
> 4) Is there anything else that can make a packet deviate (cf: DROP)

You might be interested in a picture I drew, with some help of Steven
Van Acker:

http://xkr47.outerspace.dyndns.org/netfilter/packet_flow/packet_flow9.png

> This seems the best place to get a real answer. There are lots of
> answers on google, but they all seem to be partial or even
> (occasionally) wrong. :-(

Yeah, this is the place :)

> Even the netfilter website doesn't seem to have a BIG picture ... does it?

No.. but I usually paste my picture to people on #netfilter on freenode
ircnet. :)

I agree some picture should be on the netfilter page for reference..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCohQVxyF48ZTvn+4RAugeAJ9S2u5aNhglz0n1NzB0/mZSgJN8TgCfWVX7
NlNHJGT07tv5Nf56swNHX9Q=
=G7mB
-----END PGP SIGNATURE-----
