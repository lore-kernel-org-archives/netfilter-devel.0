From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: more about martians
Date: Thu, 22 Apr 2004 10:51:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404221050190.1524-100000@filer.marasystems.com>
References: <1082622936.1826.7.camel@anduril.intranet.cartel-securite.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: udo <udovdh@yahoo.com>, <netfilter@lists.netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Cedric Blancher <blancher@cartel-securite.fr>
In-Reply-To: <1082622936.1826.7.camel@anduril.intranet.cartel-securite.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 22 Apr 2004, Cedric Blancher wrote:

> Le jeu 22/04/2004 =E0 09:54, Henrik Nordstrom a =E9crit :
> > Or simply run SSH on port 2222, nat to this port and firewall any dir=
ect=20
> > access to port 2222 with a "-j REJECT --reject-with tcp-reset" to mak=
e it=20
> > look like port 2222 is not used.
>=20
> And REDIRECT ?

Or DNAT. Any of the destination nat methods is fine..

Regards
Henrik
