From: vanuxem gregory <gvanuxem@club-internet.fr>
Subject: bug in ip6tables-save ?
Date: 06 Jul 2002 13:05:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1025953528.785.9.camel@elipse>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I add

example rules:

-A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j
log-and-drop 

ip6tables-save :

result:
-A INPUT -s ::/0 -d ::/0 -p tcp -m tcp NONE/FIN,SYN,RST,PSH,ACK,URG
-jlog-and-drop 


I don't know if it'a bug, but it's impossible to load (with ip6tables-retore) this last rule.


					Greg
