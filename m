From: paridhi bansal <paridhibansal@yahoo.com>
Subject: Ftp n iptables
Date: Fri, 21 Feb 2003 21:44:47 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030222054447.85061.qmail@web10806.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

HI!!

I wanted to ask how does an active ftp session works
in iptables with dynamic nat enabled??..Because from
my understanding of active ftp, the client sends its
ip and port to which the ftp server will connect to
for data connection..Now the server will initiate the
data connection to client at this ip and port and not
the natted ip of client it receives..How is this
handled without the use of proxy???

regards,
Paridhi

__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - forms, calculators, tips, more
http://taxes.yahoo.com/
