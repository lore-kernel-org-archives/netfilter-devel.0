From: =?utf-8?B?7J206re87IiY?= <kslee109@gmail.com>
Subject: How many rules were supported iptables?
Date: Fri, 20 Oct 2006 15:18:37 +0900
Message-ID: <003b01c6f40f$9700b2d0$1319939c@LGE.NET>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi All.
I have a problem that is how many rules were supported iptables.
The program which I maintain and repair generated iptables rules =
automatically.
Now, I encounter this problem.
Source and destination IP address is written range by user.( ex, =
1.1.1.1~1.1.1.10 ) then our program generated 10 IP address(1.1.1.1, =
1.1.1.2, 1.1.1.3, =E2=80=A6 , 1.1.1.10) and make 10 iptables rules.
Unfortunately, user wrote iptables rules like this, 10,000 rules is =
generated.
=E3=80=80=E2=80=9C iptalbes =E2=80=93A FORWARD =E2=80=93p tcp =E2=80=93s =
1.1.1.1~1.1.1.100 =E2=80=93d 2.2.2.1~2.2.2.100 =E2=80=93j =
QUEUE=E2=80=9D.
Do 10,000 rules operate safely?? Or Some rules don=E2=80=99t operate =
normally??
If some rules don=E2=80=99t operate normally, how many rules iptables =
does support??
