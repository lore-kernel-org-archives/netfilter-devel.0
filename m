From: Cedric Blancher <blancher@cartel-securite.fr>
Subject: Re: patch for rule insert
Date: Tue, 04 Jul 2006 07:31:57 +0200
Message-ID: <1151991117.4024.4.camel@anduril.intranet.cartel-securite.net>
References: <44A9E239.8080403@rocsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun <varun@rocsys.com>
In-Reply-To: <44A9E239.8080403@rocsys.com>
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

Le mardi 04 juillet 2006 =E0 09:06 +0530, varun a =E9crit :
>                 That is with -A we append the new rule and -I we add the=20
> new rule to the top of the chain. So i wold like to insert it in middle=20
> of the chain. Is it possible? Does anyone have a patch for the same?

man ipchains

[...]
SYNOPSIS
[...]
       ipchains -[RI] chain rulenum rule-specification [options]
[...]
       -I, --insert
              Insert one or more rules in the selected chain as the
              given rule number. So, if the rule number is 1, the
              rule or rules are inserted at the head of the chain.

Seems it's been there from the beginning :)

	iptables -I INPUT 4 ...

Will insert rule at 4th position.


--=20
http://sid.rstack.org/
PGP KeyID: 157E98EE FingerPrint: FA62226DA9E72FA8AECAA240008B480E157E98EE
>> Hi! I'm your friendly neighbourhood signature virus.
>> Copy me to your signature file and help me spread!
