From: Fallucchi Antonio <fallucch@csr.unibo.it>
Subject: create dynamic rules..
Date: Sat, 12 Jun 2004 00:18:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CA2FBF.6020103@csr.unibo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

hi all,

I'm e beginner in network developing. I would like to how to create 
dynamic rules in a netfilter firewall.
I have to create rules like these:

iptables -t nat -A OUTPUT -d ! 127.0.0.1 -p tcp --destination-port 80 
--tcp-flags syn syn -j QUEUE
iptables -t nat -A OUTPUT -p tcp -d ! 127.0.0.1  -j DNAT --to 127.0.0.1:80

I started using libiptc, in particular the iptc_insert_entry  function, 
but didn't understand how to fill the
ipt_entry struct.
can anyone help me?

tax.
Ciao :-)

-- 
 ---------------------------------------------------------------
| |||||||    ||    |  Fallucchi Antonio Giuseppe  mat. 2282     |
| ||        ||||    |      --> Live free() of die() <--         |
| ||||     ||  ||    |        OpenSource philisophy             |
| ||      ||||||||    |  Universita' di Bologna sede di Cesena  |
| ||     ||      ||    |        Computer Sience Romagna  	|
 ---------------------------------------------------------------
