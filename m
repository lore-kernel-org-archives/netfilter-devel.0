From: joer@netcourrier.com
Subject: HTTP info filter
Date: Thu,  4 Aug 2005 18:30:55 +0200
Message-ID: <mnet1.1123173055.14289.joer@netcourrier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I want to filter an outgoing HTTP request using its info field.
ex : HTTP =22GET /toto://hello/xxx=22
For every HTTP request with toto in info field, I wan't to get the xxx fie=
ld. This request can be dropped.
Can I do this with iptables ?
Is there another tool for this ?

Thanks in advance for your help,
Joe

-------------------------------------------------------------
NetCourrier, votre bureau virtuel sur Internet : Mail, Agenda, Clubs, Tool=
bar...
Web/Wap : www.netcourrier.com
T=E9l=E9phone/Fax : 08 92 69 00 21 (0,34 =80 TTC/min)
Minitel: 3615 NETCOURRIER (0,16 =80 TTC/min)
