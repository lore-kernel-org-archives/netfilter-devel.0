From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: more about martians
Date: Thu, 22 Apr 2004 10:35:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1082622936.1826.7.camel@anduril.intranet.cartel-securite.net>
References: <Pine.LNX.4.44.0404220943170.1524-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: udo <udovdh@yahoo.com>, netfilter@lists.netfilter.org,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404220943170.1524-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le jeu 22/04/2004 =E0 09:54, Henrik Nordstrom a =E9crit :
> Or simply run SSH on port 2222, nat to this port and firewall any direc=
t=20
> access to port 2222 with a "-j REJECT --reject-with tcp-reset" to make =
it=20
> look like port 2222 is not used.

And REDIRECT ?

--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
