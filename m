From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: SNAT table!?
Date: Thu, 24 Jun 2004 19:36:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406241936060.24475-100000@filer.marasystems.com>
References: <20040624133247.M60452@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Daniel_Corr=EAa_de_A?=zevedo <nielca@linkexpress.com.br>
In-Reply-To: <20040624133247.M60452@linkexpress.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 24 Jun 2004, Daniel Corr=EAa de Azevedo wrote:

> I need to find where do Iptables/netfilter save information about in/ou=
t=20
> traffic SNAT, once it has to associate to who is talking to who. What I=
 mean=20
> to ask is if is there any file like /proc/net/ip_conntrack (for connect=
ion=20
> traking) for SNAT?

The information is there.

> How are timeouts managed?

The normal connection timeouts applies. NAT does not modify timeouts in=20
any manner.

Regards
Henrik
