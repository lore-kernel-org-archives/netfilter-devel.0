From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Mon, 31 Oct 2005 09:28:11 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net> <436398C7.4070402@fliegl.de>
	<4365A097.1080001@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1043949209-1130747291=:9468"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4365A097.1080001@eurodev.net>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1043949209-1130747291=:9468
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Mon, 31 Oct 2005, Pablo Neira wrote:

<CIACH>
> I've been giving some testing to the conntrack tool and seems to work fin=
e=20
> under big stress situation. If you spot any other bug, please let me know=
=2E=20
> I'm willing to do the first 1.0 official as soon as people don't complain=
=20
> about bugs.

1. "Illegal option `-m'" with "conntrack -E -i"
# conntrack -E -i
conntrack v0.94: Illegal option `-m' with this command

2. Unable to delete conntrack by id:
root@olemx:~# conntrack -L -i|grep id=3D101
tcp      6 431999 ESTABLISHED src=3D192.168.0.22 dst=3D192.168.0.33 sport=
=3D1607 dport=3D22 packets=3D72520 bytes=3D4421477 src=3D192.168.0.33 dst=
=3D192.168.0.22 sport=3D22 dport=3D1607 packets=3D101332 bytes=3D21675629 [=
ASSURED] mark=3D0 use=3D1 id=3D101
root@olemx:~# conntrack -D -i 101
root@olemx:~# conntrack -L -i|grep id=3D101
tcp      6 431999 ESTABLISHED src=3D192.168.0.22 dst=3D192.168.0.33 sport=
=3D1607 dport=3D22 packets=3D72549 bytes=3D4423573 src=3D192.168.0.33 dst=
=3D192.168.0.22 sport=3D22 dport=3D1607 packets=3D101352 bytes=3D21677725 [=
ASSURED] mark=3D0 use=3D1 id=3D101

3. "deficit (4) len (0)." in conntrack -E expect:

# conntrack -E expect
0 proto=3D17 src=3D192.168.31.255 dst=3D192.168.1.29 sport=3D138 dport=3D13=
8
nfnl_parse_attr: deficit (4) len (0).

0 proto=3D17 src=3D192.168.31.255 dst=3D192.168.1.227 sport=3D138 dport=3D1=
38
nfnl_parse_attr: deficit (4) len (0).

4. Wrong formating in conntrack -h (Get... & Update...)

Commands:
-L [table] [-z]         List conntrack or expectation table
-G [table] parameters  Get conntrack or expectation
-D [table] parameters   Delete conntrack or expectation
-I [table] parameters   Create a conntrack or expectation
-U [table] parameters  Update a conntrack
-E [table] [options]    Show events
-F [table]              Flush table

Patch attached & inlined (for easy review):

Index: src/conntrack.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/conntrack.c=09(revision 4397)
+++ src/conntrack.c=09(working copy)
@@ -670,13 +670,13 @@
  fprintf(stdout, "Usage: %s [commands] [options]\n", prog);
  fprintf(stdout, "\n");
  fprintf(stdout, "Commands:\n");
-fprintf(stdout, "-L [table] [-z]   =09List conntrack or expectation table\=
n");
-fprintf(stdout, "-G [table] parameters  Get conntrack or expectation\n");
-fprintf(stdout, "-D [table] parameters=09Delete conntrack or expectation\n=
");
-fprintf(stdout, "-I [table] parameters=09Create a conntrack or expectation=
\n");
-fprintf(stdout, "-U [table] parameters  Update a conntrack\n");
-fprintf(stdout, "-E [table] [options]=09Show events\n");
-fprintf(stdout, "-F [table]=09     =09Flush table\n");
+fprintf(stdout, "-L [table] [-z]\t\tList conntrack or expectation table\n"=
);
+fprintf(stdout, "-G [table] parameters\tGet conntrack or expectation\n");
+fprintf(stdout, "-D [table] parameters\tDelete conntrack or expectation\n"=
);
+fprintf(stdout, "-I [table] parameters\tCreate a conntrack or expectation\=
n");
+fprintf(stdout, "-U [table] parameters\tUpdate a conntrack\n");
+fprintf(stdout, "-E [table] [options]\tShow events\n");
+fprintf(stdout, "-F [table]\t\tFlush table\n");
  fprintf(stdout, "\n");
  fprintf(stdout, "Options:\n");
  fprintf(stdout, "--orig-src ip=09     =09Source address from original dir=
ection\n");

5. Missing information in help/man about possibility of using "-i".

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-1043949209-1130747291=:9468
Content-Type: TEXT/PLAIN; charset=US-ASCII; name=conntrack.c-fixhelp
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.62.0510310928110.9468@bizon.gios.gov.pl>
Content-Description: 
Content-Disposition: attachment; filename=conntrack.c-fixhelp

SW5kZXg6IHNyYy9jb25udHJhY2suYw0KPT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KLS0tIHNyYy9jb25udHJhY2suYwkocmV2aXNpb24gNDM5NykNCisrKyBz
cmMvY29ubnRyYWNrLmMJKHdvcmtpbmcgY29weSkNCkBAIC02NzAsMTMgKzY3
MCwxMyBAQA0KIGZwcmludGYoc3Rkb3V0LCAiVXNhZ2U6ICVzIFtjb21tYW5k
c10gW29wdGlvbnNdXG4iLCBwcm9nKTsNCiBmcHJpbnRmKHN0ZG91dCwgIlxu
Iik7DQogZnByaW50ZihzdGRvdXQsICJDb21tYW5kczpcbiIpOw0KLWZwcmlu
dGYoc3Rkb3V0LCAiLUwgW3RhYmxlXSBbLXpdICAgCUxpc3QgY29ubnRyYWNr
IG9yIGV4cGVjdGF0aW9uIHRhYmxlXG4iKTsNCi1mcHJpbnRmKHN0ZG91dCwg
Ii1HIFt0YWJsZV0gcGFyYW1ldGVycyAgR2V0IGNvbm50cmFjayBvciBleHBl
Y3RhdGlvblxuIik7DQotZnByaW50ZihzdGRvdXQsICItRCBbdGFibGVdIHBh
cmFtZXRlcnMJRGVsZXRlIGNvbm50cmFjayBvciBleHBlY3RhdGlvblxuIik7
DQotZnByaW50ZihzdGRvdXQsICItSSBbdGFibGVdIHBhcmFtZXRlcnMJQ3Jl
YXRlIGEgY29ubnRyYWNrIG9yIGV4cGVjdGF0aW9uXG4iKTsNCi1mcHJpbnRm
KHN0ZG91dCwgIi1VIFt0YWJsZV0gcGFyYW1ldGVycyAgVXBkYXRlIGEgY29u
bnRyYWNrXG4iKTsNCi1mcHJpbnRmKHN0ZG91dCwgIi1FIFt0YWJsZV0gW29w
dGlvbnNdCVNob3cgZXZlbnRzXG4iKTsNCi1mcHJpbnRmKHN0ZG91dCwgIi1G
IFt0YWJsZV0JICAgICAJRmx1c2ggdGFibGVcbiIpOw0KK2ZwcmludGYoc3Rk
b3V0LCAiLUwgW3RhYmxlXSBbLXpdXHRcdExpc3QgY29ubnRyYWNrIG9yIGV4
cGVjdGF0aW9uIHRhYmxlXG4iKTsNCitmcHJpbnRmKHN0ZG91dCwgIi1HIFt0
YWJsZV0gcGFyYW1ldGVyc1x0R2V0IGNvbm50cmFjayBvciBleHBlY3RhdGlv
blxuIik7DQorZnByaW50ZihzdGRvdXQsICItRCBbdGFibGVdIHBhcmFtZXRl
cnNcdERlbGV0ZSBjb25udHJhY2sgb3IgZXhwZWN0YXRpb25cbiIpOw0KK2Zw
cmludGYoc3Rkb3V0LCAiLUkgW3RhYmxlXSBwYXJhbWV0ZXJzXHRDcmVhdGUg
YSBjb25udHJhY2sgb3IgZXhwZWN0YXRpb25cbiIpOw0KK2ZwcmludGYoc3Rk
b3V0LCAiLVUgW3RhYmxlXSBwYXJhbWV0ZXJzXHRVcGRhdGUgYSBjb25udHJh
Y2tcbiIpOw0KK2ZwcmludGYoc3Rkb3V0LCAiLUUgW3RhYmxlXSBbb3B0aW9u
c11cdFNob3cgZXZlbnRzXG4iKTsNCitmcHJpbnRmKHN0ZG91dCwgIi1GIFt0
YWJsZV1cdFx0Rmx1c2ggdGFibGVcbiIpOw0KIGZwcmludGYoc3Rkb3V0LCAi
XG4iKTsNCiBmcHJpbnRmKHN0ZG91dCwgIk9wdGlvbnM6XG4iKTsNCiBmcHJp
bnRmKHN0ZG91dCwgIi0tb3JpZy1zcmMgaXAJICAgICAJU291cmNlIGFkZHJl
c3MgZnJvbSBvcmlnaW5hbCBkaXJlY3Rpb25cbiIpOw0K

---187430788-1043949209-1130747291=:9468--
