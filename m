From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: Tapping ARP add
Date: Sat, 18 Dec 2004 11:38:16 +0100
Message-ID: <1103366296.4049.3.camel@anduril.intranet.cartel-securite.net>
References: <BB6D74C75CC76A419B6D6FA7C38317B259F53F@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Vishwas Manral <Vishwas@sinett.com>
In-Reply-To: <BB6D74C75CC76A419B6D6FA7C38317B259F53F@sinett-sbs.SiNett.LAN>
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

Le vendredi 17 d=E9cembre 2004 =E0 23:51 -0800, Vishwas Manral a =E9crit :
> Is there a way (like netfilter is for tapping packets) by which I can
> register a function which gets called whenever an ARP cache entry is
> added or deleted?

Netfilter will only provide you a way of tapping ARP traffic using
arptables. BTW, there's no driect relation ship between ARP traffic and
cache behaviour unless you just reimplement a ARP cache like "ARP state
tracking" on top of arptables. I really don't think Netfilter can help
you on this.

But you can still have a look at ARP daemon code, because it has a
direct relationship with kernel ARP cache and sure can help you.


--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
