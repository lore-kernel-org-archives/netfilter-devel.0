From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: Second Request for help!!
Date: Mon, 7 Feb 2005 10:32:57 -0500 (EST)
Message-ID: <54116.142.169.215.10.1107790377.squirrel@142.169.215.10>
References: <200502071457.j17EvuYX018439@commserver.noach.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
In-Reply-To: <200502071457.j17EvuYX018439@commserver.noach.com>
To: "John Hill" <jhill@noach.com>
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

*CC'ed on netfilter-devel@lists.netfilter.org*

On Mon, February 7, 2005 9:57 am, John Hill said:
> Kernel 2.4.29
> Patch-0-Matic 2005 02 01 patched for fixes and pptp
> iptables-1.3.0rc1

uhm.. kernel 2.4.29...

>
> 20+ errors in ipv4 and ipv6 about Declare_Mutex declared static but nev=
er
> defined defaults to int etc.
> Some are ipv4/iptables.h:339 and ipv6/ip6_tables.h:109 all about
> Declare_Mutex errors?

Can you please post the complete gcc warnings/errors you get on:

        netfilter-devel@lists.netfilter.org


>
> I have had these errors on all iptables except 1.2.11 and pom2040621. I
> have
> not been able to update since 6-2004.
> I searched the lists and found some mention but no clear answer.
>
> Thanks
>
> --john
>

Regards,
Samuel
