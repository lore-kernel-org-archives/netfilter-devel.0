From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: [RFC] ipt_REJECT.c - option to use different ICMP source address
Date: Tue, 5 Nov 2002 10:18:53 +0100
Sender: bridge-admin@math.leidenuniv.nl
Message-ID: <20021105091853.GB576@siri>
References: <20021102153451.N8635@sunbeam.de.gnumonks.org> <200211022032.46007.bart.de.schuymer@pandora.be> <20021104092757.C8635@sunbeam.de.gnumonks.org> <200211042343.19949.bart.de.schuymer@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@gnumonks.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   bridge@math.leidenuniv.nl, Pekka Savola <pekkas@netcore.fi>
Return-path: <bridge-admin@math.leidenuniv.nl>
To: Bart De Schuymer <bart.de.schuymer@pandora.be>
Content-Disposition: inline
In-Reply-To: <200211042343.19949.bart.de.schuymer@pandora.be>
Errors-To: bridge-admin@math.leidenuniv.nl
List-Help: <mailto:bridge-request@math.leidenuniv.nl?subject=help>
List-Post: <mailto:bridge@math.leidenuniv.nl>
List-Subscribe: <http://www.math.leidenuniv.nl/mailman/listinfo/bridge>,
	<mailto:bridge-request@math.leidenuniv.nl?subject=subscribe>
List-Unsubscribe: <http://www.math.leidenuniv.nl/mailman/listinfo/bridge>,
	<mailto:bridge-request@math.leidenuniv.nl?subject=unsubscribe>
List-Archive: <http://www.math.leidenuniv.nl/pipermail/bridge/>
List-Id: netfilter-devel.vger.kernel.org

Hi Bart,

Dans un message du 04 Nov =E0 23:43, Bart De Schuymer =E9crivait :
> So, if I were to implement code inside ipt_REJECT.c (for 2.5) that
> checks if the packet is being bridged and we are on the NF_IP_FORWARD
> hook. And if so, it uses the destination address of the original
> packet as the source address of the ICMP message. Would this then be
> accepted (if it looks ok)?  Ofcourse, this code would only be compiled
> if the bridge is enabled.

Something in the patch-o-matic already does that. Look at
http://www.netfilter.org/documentation/pomlist/pom-userspace.html#ipt_REJ=
ECT-fake-source

I guess you would just need to slightly modify it.

Regards,

--=20
Guillaume Morin <guillaume@morinfr.org>

                       Pastis servi, pastis bu (Patrice)
