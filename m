From: "Martin Bene" <martin.bene@icomedias.com>
Subject: really fix iplimit 'second try' bug
Date: Sat, 23 Nov 2002 14:00:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4D618F6493CE064A844A5D496733D6670314EC@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <laforge@gnumonks.org>
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

There's still a problem in the iplimit module: when trying to connect =
using
the same source port twice, the second connection succeeds.
The patch proposed by Sumit Pandya sumit@elitecore.com for fixing this
doesn't work - it doesn't address the actual problem.

Please remove the non-working fix from cvs; I've posted a working patch =
to
the list (see
http://lists.netfilter.org/pipermail/netfilter-devel/2002-November/009849=
.htm
l)

To sum up the problem:=20
iplimit keeps a list of active connections for each rule; new =
connections are
only added (and counted against the limit) if they don't yet exist on =
the
list. Current code disregards the new connection even if the found list =
entry
describes a connection that doesn't exist any longer (and gets removed =
from
the list a few lines further down). the patch changes this to ignore the
packet only if the found table extry describes a connection that's still
valid.

Bye, Martin
