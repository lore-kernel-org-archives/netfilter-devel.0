From: Jimmy Hedman <jimmy.hedman@southpole.se>
Subject: Differences between MASQ and SNAT
Date: Mon, 09 Feb 2004 13:42:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1076330570.8454.13.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Mailing List <netfilter@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,
What's the REAL differences between MASQ and SNAT? I've had a problem
where it didn't work with SNAT but it did work with MASQ...
The setup was two firewalls (A and B) with a Ipsec tunnel between them
and and another VPN onward from B. The old setup was to masquerade all
the traffic from site A, even the traffic out on the VPN between FW A
and FW B. Due to some other changes i had to remove the masquerade for
traffic the over the VPN and do SNAT on FW B instead. This worked for
everything but one machine. If i turned on MASQ for that machine on FW A
everything worked again which made me puzzled what MASQ is doing that
SNAT isn't.

So, does MASQ do anything that SNAT doesn't in form of changing the
header or such? Or should i find the answer in the Windows machine that
was putting up the fight?

// Jimmy



--=20
Jimmy Hedman                       South Pole AB
Phone:  +46 8 51420420             Gelbjutarv=E4gen 5
Fax:    +46 8 51420429             SE - 17148 Solna=20
e-mail: jimmy.hedman@southpole.se  www.southpole.se
