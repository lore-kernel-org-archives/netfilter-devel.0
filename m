From: Artur Frycze <mayday@rave.eu.org>
Subject: iptables man page
Date: Tue, 22 Jul 2003 00:29:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307220030.02570.mayday@rave.eu.org>
Reply-To: mayday@rave.eu.org
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Description: clearsigned data
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

=2D----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello.

I think there is a bug in iptables man page:

       [!] --syn
              Only match TCP packets with the SYN bit set and the
              ACK and FIN bits cleared.  Such packets are used to
              request  TCP  connection  initiation;  for example,
              blocking such packets coming in an  interface  will
              prevent  incoming TCP connections, but outgoing TCP
              connections will be unaffected.  It  is  equivalent
              to  --tcp-flags  SYN,RST,ACK  SYN.  If the "!" flag
              precedes the "--syn", the sense of  the  option  is
              inverted.

so, --syn means to match packets with SYN set, and the ACK and FIN cleared
thats not the same as:
	--tcp-flags  SYN,RST,ACK  SYN
which matches packets with SYN flag set, and RST and ACK cleared
=2D - they are not equivalent.

i've checked - they realy ARE equivalent, so the man page should say:

       [!] --syn
              Only match TCP packets with the SYN bit set and the
              ACK and RST bits cleared............

the flag that is cheched is RST not FIN.

=2D --=20
Artur Frycze <mayday@rave.eu.org>
Warsaw University of Technology


**********************************************
my PGP public key is available at pgp.mit.edu
key fingerprint:
874B 0F52 7A1B BE6F 7232  0931 B2C4 C462 1F80 4A19


=2D----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/HGlmssTEYh+AShkRAnyCAJ4xVx2YSUeUuc7MNKBbKdUSe1ZDkQCdEwty
0SNTv8c1GkXLFq1xjezhPw4=3D
=3DE6Um
=2D----END PGP SIGNATURE-----
