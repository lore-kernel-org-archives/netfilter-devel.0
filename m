From: Jim Gifford <maillist@jg555.com>
Subject: IPTables 1.3.0 on RaQ2
Date: Fri, 04 Mar 2005 19:23:46 -0800
Message-ID: <42292642.6030504@jg555.com>
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

When I tried to compile iptables 1.3.0 on a MIPS based machine (Cobalt 
RaQ2), I get the following error.

# make BINDIR="/usr/bin" LIBDIR="/usr/lib" MANDIR="/usr/man"
Making dependencies: please wait...
Something wrong... deleting dependencies.
make: *** [cpu-feature-overrides.h] Error 1


Any suggestions
