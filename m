From: macadanet@yahoo.es
Subject: string match -> new option
Date: Sat, 1 Mar 2003 02:53:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15760529186.20030301025308@yahoo.es>
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


Hi.

I'm sorry for my english

I modificated ipt_string.c and I created a new patch. This patch
acepts regular expresions.

For example:

iptables -A INPUT -m string --string '"GET"[0-9]"HTTP"' -j LOG

If some package includes the string: GET ???????8????????? HTTP
the system will write in log file.

It's a good idea, for firewalls between WAN network (Internet) and LAN
network where exists some IIS server (Internet Information Servers).
This server are great bugs when received bad requests like:

"http://www.servidor.com/msadc/..%c0%af../..%c0%af../..%c0%af../winnt/system32/cmd.exe?/c+dir+c:\"
attack with Unicodes


GET http://<ipaddress>/default.ida?NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN
NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN%u9090%u6858%ucbd3%u7
801%u9090%u6858%ucbd3%u7801%u9090%u6858%ucbd3%u7801%u9090%u9090%u8190%
u00c3%u0003%u8b00%u531b%u53ff%u0078%u0000%u00=a HTTP/1.0
Red Code Virus.

this solution can be apply to diferents kind servers.


What do people think? Is a good idea?


Thanks for read this (my) email.


___________________________________________________
Yahoo! Móviles
Personaliza tu móvil con tu logo y melodía favorito 
en http://moviles.yahoo.es
