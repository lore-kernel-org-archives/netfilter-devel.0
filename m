From: tuXit <tuxit@netcourrier.com>
Subject: New standalone nat helper module which help function is never
 called
Date: Mon, 17 Nov 2003 17:48:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031117174829.711e2e82.tuxit@netcourrier.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Hi all,

I am new in netfilter development, and I'm working on creating a module in
order to modify tcp packets "on the fly", for some ASCII protocols (I first
develop using the NNTP one). The final goal is to say in iptables which
pattern of the packet toward a port to match, and with what to replace it.

Anyway, my problem is not yet in iptables, but in the nat helper module.
I created one, defined as standalone ('cause no related connection is
expected), defining that it uses the tcp protocol, the NNTP port (119), the
masks... I inspired myself from the ftp nat helper and the snmp one (that is
also standalone).

In the end, I insmod my module (which is marked as unused), and the logs show
that it is properly registered. I said in iptables to accept the packets
from/toward the NNTP port (119), and I also said to masquerade from one
network to the other. When trying to contact the NNTP server on the other
network from a client machine in the first network and using the machine on
which I inserted the module as gate, the help function of my module is never
called. There must be something I forgot, or I wrongly understood, but after
having read several times the kernel hacking guide and searched inside this
mailing-list archive, I can't find any reason.

I somebody has an idea about it, I would be glad to know it :)
Thanks in advance,
tuXit.
-- 
Florian Pouradier
echo '|^H_!Xn|^H_' | less 
EpX Member - Debian GNU/Linux user
GPG FP: B0D7 1F53 94DA 0BCA C11E  F417 094B 49F3 D5DD F5EC 
