From: namelesspirate@gmx.net
Subject: what to expect ?
Date: Wed, 15 Oct 2003 12:04:54 +0200 (MEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <24158.1066212294@www55.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

my setup is the following:
HOST1 <-> GW <-> SERVER <-> HOST2
    <---------------DATA------------->

HOST1 opens a control-connection to the SERVER which is nat'd by GW.
Now either HOST1 (or HOST2) issue a call to the SERVER, which is nat'd to
HOST2 (or HOST1).
This host answers with connection information for a data connection, that
gets rewritten by GW and is transfered via the server to the other host.
Now the hosts try to establish the data connection. I have ip/port-tuples
for both ends of the connection.
My question is how should the expectation look like ?
src: host2-ip/port  dst: gw-ip/port is what I think is correct. (if HOST1
issued the call)
and when does ip_nat_expected get called ? and how should I alter src and
dst ip in ip_nat_expected ?
So far I only got the data goin' in one direction.

regards

niKolAi

-- 
NEU FÜR ALLE - GMX MediaCenter - für Fotos, Musik, Dateien...
Fotoalbum, File Sharing, MMS, Multimedia-Gruß, GMX FotoService

Jetzt kostenlos anmelden unter http://www.gmx.net

+++ GMX - die erste Adresse für Mail, Message, More! +++
