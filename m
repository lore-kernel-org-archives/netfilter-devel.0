From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: limit and negation
Date: Tue, 09 Nov 2004 16:53:07 +0100
Message-ID: <1100015587.8753.46.camel@anduril.intranet.cartel-securite.net>
References: <1099995187.4318.15.camel@porky>
	<33091.66.11.161.14.1100010503.squirrel@66.11.161.14>
	<1100013282.4439.1.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org,
	Nicolas Bouliane <nib@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1100013282.4439.1.camel@porky>
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

Le mardi 09 novembre 2004 =E0 16:14 +0100, Eric Leblond a =E9crit :
> I try this one too, but it should not accept this command as it does
> now :
> >> iptables -A OUTPUT -m limit ! --limit 1/s -j LOG --log-prefix "over"

Last time I tried, rule was accepted by iptables, bu was acting ignoring
inversion statement. So just like you was stating before.

By the way, you can invert limit (as well as any match you may need)
using a user chain :

	iptables -N MYLIMIT
	iptables -A MYLIMIT -m limit --limit 1/s -j RETURN
	iptables -A MYLIMIT -j LOG --log-prefix "over"
	iptables -A OUTPUT -j MYLIMIT


--=20
http://www.netexit.com/~sid/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
