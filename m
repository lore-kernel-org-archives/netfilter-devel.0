From: P@draigBrady.com
Subject: Re: performance
Date: Mon, 09 Jun 2003 17:16:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EE4B2E3.2070700@draigBrady.com>
References: <3EE4B1EB.9090305@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <3EE4B1EB.9090305@draigBrady.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

P@draigBrady.com wrote:
> Hi,
>=20
> I'm testing netfilter performance here on
> PIII 1.2GHz based systems. With default
> kernel configuration, netfilter is able
> to process 85,000 pps with 125 rules (all
> rules matching).
>=20
> Note the application is just counting.
> There is no transmitting/forwarding.
>=20
> Also note the nics are e100.
>=20
> So my simple question are there any
> tips in increasing the performance?
> Hmm actually the performance seems
> optimal? is it only taking 9 instructions
> per match? 1.2*10^9/(85000*1500) =3D 9

I knew that couldn't be right.
That was tested on a dual 1.2GHz,
so that should be approx:
2*10^9/(85000*125) =3D 188 instructions per match.

I guess that's pretty optimal?
The best I could hope for after that
would be to increase the rx packet
buffer space so as to handle higher
spikes than this.

cheers,
P=E1draig.
