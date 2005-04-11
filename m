From: =?ISO-8859-1?Q?Jo=E3o_Paulo_Caldas_Campello?= <protecao@gmail.com>
Subject: Any way to automatically change arbitrary headers of IP packets
	on-the-fly?
Date: Mon, 11 Apr 2005 19:46:40 -0300
Message-ID: <fcff0b6405041115466c6ece05@mail.gmail.com>
References: <fcff0b64050411153958ce0d27@mail.gmail.com>
Reply-To: =?ISO-8859-1?Q?Jo=E3o_Paulo_Caldas_Campello?= <protecao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <fcff0b64050411153958ce0d27@mail.gmail.com>
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

Hi,

    I've sent the message below to a bunch of other mailing lists, but
I think the topic is also pertinent to the netfilter-devel one. Sorry
if I'm wrong.

    I would like to know if there's a simple way (using netfilter) to
alter arbitrary headers of IP packets, specially the "IP Options"
fields, so I can do some research and sort of lab and penetration
tests regarding semi-blind IP spoofing (i.e. Loose/Strict IP Source
Routing).

Any help is appreciated,

Thanks,

Jo=E3o Paulo Campello.

---------- Forwarded message ----------
From: Jo=E3o Paulo Caldas Campello <protecao@gmail.com>
Date: Apr 11, 2005 7:39 PM
Subject: Any way to automatically change arbitrary headers of IP
packets on-the-fly?
To: pen-test@securityfocus.com
Cc: security-management@securityfocus.com,
secpapers@securityfocus.com, vuln-dev@securityfocus.com,
focus-linux@securityfocus.com, libnet@securityfocus.com,
firewalls@securityfocus.com, security-basics@securityfocus.com


Hi,

  Does anybody know any userland tool, Linux kernel module,
iptables/netfilter module, or whatever mechanism to change arbitrary
headers of IP packets on-the-fly as long as they traverse the IP
stack? Is there any known paper regarding this subject?

  The whole story is that I'm doing some research and lab tests on
semi-blind IP spoofing (i.e. Loose/Strict IP Source Routing) on
borders routers and firewalls, so I need an easy way to alter the "IP
Options" fields of IP packets to test if the routers/firewalls are
vulnerable to IP spoofing (e.g. not doing ingress filtering) in
conjunction with source routing techniques.

  Yes, I know most modern firewalls should just drop IP Options
flagged packets, but not all firewalls do that with default
configurations.

  Sure I can construct raw IP packets with the proper IP Options
fields set on, but I'm also doing sort of a penetration test so I need
a way to automate this task as the packets traverse the stack. This
way I could still use well-known and proven penetration test tools
such as port and vulnerability scanners, web spiders, and so on.

  I've already read Netfilter documentation (specially the "Linux
netfilter Hacking HOWTO") so I know this kind of packet mangling can
be done in userspace. I thought it could be done in the "MANGLE" table
of netfilter, but I found no TARGET that achieves that nor any
documentation about altering arbitrary IP headers.

The question is:

  - Does already exist such a tool, module or whatever way to change
arbitrary headers of IP packets on-the-fly or will I have to (try to)
write one? =3D)

Cheers,

Jo=E3o Paulo Campello,
Network Security Analyst,
Tempest Security Technologies.
