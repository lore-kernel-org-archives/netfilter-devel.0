From: Peter <pme@ufh.se>
Subject: Re: How many rules were supported iptables?
Date: Fri, 20 Oct 2006 08:43:33 +0200
Message-ID: <45387015.40305@ufh.se>
References: <003e01c6f410$f70baf30$1319939c@LGE.NET>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?UTF-8?B?7J206re87IiY?= <kslee109@gmail.com>
In-Reply-To: <003e01c6f410$f70baf30$1319939c@LGE.NET>
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

=EC=9D=B4=EA=B7=BC=EC=88=98 wrote:

>Hi All.
>I have a problem that is how many rules were supported iptables.
>The program which I maintain and repair generated iptables rules automat=
ically.
>Now, I encounter this problem.
>Source and destination IP address is written range by user.( ex, 1.1.1.1=
~1.1.1.10 ) then our program generated 10 IP address(1.1.1.1, 1.1.1.2, 1.=
1.1.3, =E2=80=A6 , 1.1.1.10) and make 10 iptables rules.
>Unfortunately, user wrote iptables rules like this, 10,000 rules is gene=
rated.
>=E3=80=80=E2=80=9C iptalbes =E2=80=93A FORWARD =E2=80=93p tcp =E2=80=93s=
 1.1.1.1~1.1.1.100 =E2=80=93d 2.2.2.1~2.2.2.100 =E2=80=93j QUEUE=E2=80=9D.
>Do 10,000 rules operate safely?? Or Some rules don=E2=80=99t operate nor=
mally??
>If some rules don=E2=80=99t operate normally, how many rules iptables do=
es support??
>
>
> =20
>
It's the 4 MB in total size of rules. (This is the maximum size of a=20
chunc of data copy from userspace to kernel space in
one syscall)
