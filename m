From: "William da Rocha Lima" <wrochal@linuxit.com.br>
Subject: Error in rules DNAT
Date: Sun, 29 Jun 2003 20:22:58 +0000 (UTC)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <007b01c34328$5449a050$0100000a@william>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <blueflux@koffein.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
Date: Sat, 5 Jul 2003 16:04:55 -0300
List-Id: netfilter-devel.vger.kernel.org

Oskar Andreasson,

Verifies that rule DNAT this incorrect one:
iptables - t nat - the PREROUTING - p tcp - d 15,45,23,67 -- dport 80 - j
DNAT -- to-destination 192,168,1,1

the correct one is:

iptables - t nat - the PREROUTING - p tcp - i ethX - d 15,45,23,67 -- 
dport - 80 j DNAT -- to-destination 192,168,1,1

being that ethX is entrance interface

Articles write iam:
http://www.linuxit.com.br/modules.php?name=Sections&op=viewarticle&artid=21

bye,

====================
William da Rocha Lima
wrochal@linuxit.com.br
www.linuxit.com.br
