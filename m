From: macadanet@yahoo.es
Subject: my new option calls httpr
Date: Sat, 1 Mar 2003 12:40:05 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <618861251.20030301124005@yahoo.es>
Reply-To: macadanet@yahoo.es
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: lista de correo netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


When I didn't modify -string option. I created a new option -httpr
(http request).

I had done a test suite above my network with this patch aplied. In
Input string on NETFILTER hook, I had a 4 rules:

iptables -A INPUT -m httpr --httpr '"GET"?"cmd.exe"?"dir"?"HTTP"'
-j LOG
iptables -A INPUT -m httpr --httpr '"GET"?"tftp"?"HTTP"'
-j LOG
iptables -A INPUT -m httpr --httpr '"GET"?"root.exe"?"HTTP"'
-j LOG
iptables -A INPUT -m httpr --httpr '"GET"?"default.ida"?[XNO]*?"HTTP"'
-j LOG

My regexp library recognices the rules before showed.

In this host (it's a gateway) is installed a ftp server (proftp
server). From other host established a ftp connexion to this gate with
 NETFILTER on. PUT and GET binaries files, from and to this gateway
 and bandwith was ok. (5000 Kb/s).

I hope that my explanation was good and people understand me.

Sorry for my horrible english.


___________________________________________________
Yahoo! Móviles
Personaliza tu móvil con tu logo y melodía favorito 
en http://moviles.yahoo.es
