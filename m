From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Re: ip_rt_bug in mangle/OUTPUT
Date: Tue, 05 Jun 2007 14:20:26 -0600
Message-ID: <4665C58A.6070401@cpsc.ucalgary.ca>
References: <4654AE59.3090506@cpsc.ucalgary.ca> <4655D083.8070309@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC6B99803C4A9BC74302E434B"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4655D083.8070309@trash.net>
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC6B99803C4A9BC74302E434B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Patrick McHardy wrote:
> Rennie deGraaf wrote:
>> I seem to be getting the error message
>>     ip_rt_bug: 10.1.1.1 -> 10.0.1.2, ?
>> whenever I attempt to send a packet with a non-local source IP address=

>> (my local IP address is 10.0.1.2) from libipq in mangle/OUTPUT.  I hav=
e
>> observed this behaviour under Linux kernels 2.6.20.7 and
>> 2.6.18-1.2257.fc5smp (Fedora Core 5), and iptables versions 1.3.5 and
>> 1.3.7.
>>
>> I'm trying to simulate connections with remote hosts by redirecting
>> packets to servers listening on localhost.  My strategy is to send
>> packets to IP_QUEUE from rules in the mangle/OUTPUT chain: destination=

>> addresses are re-written on packets that I want to redirect, source
>> addresses are re-written on packets on responses to redirected packets=
,
>> and other packets are passed without modification.  A simplified, high=
ly
>> stripped down version of my program is attached.
>>
>> To run my example program, you need rules in your mangle/OUTPUT chain
>> forwarding packets to 10.1.1.1:123/TCP and from 127.0.0.1:22/TCP to
>> QUEUE, and something listening on 127.0.0.1:22/TCP.  If it worked
>> properly, a connection could be successfully established to
>> 127.0.0.1:22/TCP by connecting to 10.1.1.1:123/TCP (using telnet, for
>> instance).
>>
>> Do any of the gurus on this list know how I might fix or work around
>> this issue?
>=20
>=20
> If you don't need the rerouting to be happen (you only change the
> source address and don't use routing rules based on that) you can
> simply return NF_STOP instead of NF_ACCEPT. It will do exactly
> the same thing but avoid rerouting.

That solution worked well on recent kernels.  Unfortunately, my boss now
wants my code to work on Linux 2.6.9, which doesn't appear to have
NF_STOP.  (It seems to have been added in 2.6.12.)  Can you think of any
other work-arounds, short of dropping the packets and re-injecting the
modified versions through raw sockets?

In the meantime, I'll try to convince my boss to upgrade to a more
modern kernel.

Thanks,
Rennie deGraaf


--------------enigC6B99803C4A9BC74302E434B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFGZcWNIvU5mZP08HERAklmAJ4qdDlt961BHZDkPiSkUVdfooosGgCg4box
o3vK2RxRwDoXLjwfuoXM40I=
=aE3z
-----END PGP SIGNATURE-----

--------------enigC6B99803C4A9BC74302E434B--
