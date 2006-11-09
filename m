From: "mael\.boutin" <mael.boutin@laposte.net>
Subject: Conntrack timeout
Date: Thu,  9 Nov 2006 15:09:06 +0100
Message-ID: <J8GVB6$58359DC0230295AB48BF9CF1D57F3A80@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

I wanted to know if it is possible to change the default
timeout for conntrack entries. And if a modification of these
timeout will not have border effects on other system features.

I noticed for example that the UDP timeout is set to 30
seconds if the connection is not assured and 180 in the other
case.

The problem i am facing is that i want to detect the end of a
connection as soon as possible and a delay of 1 or 2 minutes
is clearly not acceptable.

I found some conf files in /proc/sys/net/netfilter, however
not all the timeouts are represented

Thanks for your help,

Ma=EBl.=0A=0AAcc=E9dez au courrier =E9lectronique de La Poste 
sur www.laposte.net ou sur 3615 LAPOSTENET (0,34=80 TTC /mn) 
1 Giga de stockage gratuit =96 Antispam et antivirus int=E9gr=E9s 
=0A
