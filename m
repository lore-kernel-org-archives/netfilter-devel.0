From: "Martin Bene" <martin.bene@icomedias.com>
Subject: conntrack and netstat: diverging ideas of established connections
Date: Fri, 24 Jan 2003 16:24:25 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4D618F6493CE064A844A5D496733D667031692@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On a server with no forwarding I'm seeing pronounced differences =
regarding
established connections:

cat /proc/net/ip_conntrack shows ~ 150 tcp connections in "ESTABLISHED"
state;

netstat -an shows 20 established TCP connections.

especialy troubling: I find 10 concurrent connections =3D=3D> port 25 =
for a host
IP in ip_conntrack, while there actually is not a single sendmail =
session
active.

Any ideas why conntrack keeps these "ghost" connections around as avtive =
even
though they definitely don't exist?
since I'm trying to limit max concurrent connections by host using =
iplimit
these bad entries in ip_conntrack are quite troublesome.

Software: linux 2.4.19 w/ iptables-1.2.7a and pom 20020825

Thanks, Martin
********************************************************
Martin Bene,                 CTO
icomedias GmbH,              A-8020 Graz, Entenplatz 1b
t +43 (316) 721671-14,       f +43 (316) 721671-26
e martin.bene@icomedias.com, i http://www.icomedias.com
********************************************************
