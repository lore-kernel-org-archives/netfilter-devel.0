From: Andy Furniss <andy.furniss@dsl.pipex.com>
Subject: connbytes
Date: Thu, 17 Mar 2005 15:40:58 +0000
Message-ID: <4239A50A.30600@dsl.pipex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Does anyone know if connbytes + CONNMARK will work now CONNMARK and 
conntrack-acc are in kernel (using 2.6.11).

I got pom to patch (by removing dependencies) and everything compiles OK 
as modules.

I haven't tried them together yet as I can't get iptables to parse the 
options for connbytes.

iptables -t mangle -A PREROUTING -m connbytes --connbytes 0:80000 
--connbytes-dir both --connbytes-mode bytes

iptables v1.3.1: Unknown arg `bytes'

I noticed that byte would be "let through" by iptables - but failed in 
the parse bit of libipt_connbytes.c

iptables v1.3.1: Unknown --connbytes-mode `byte'

I tried changing libipt_connbytes.c to parse byte rather than bytes but 
then iptables.c accepted bytes but not byte.

I tried with and without pre loading the module.

TIA

Andy.
