From: macadanet@yahoo.es
Subject: developing netfilter patch
Date: Sat, 25 Jan 2003 05:43:59 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4664598217.20030125054359@yahoo.es>
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


I have created a patch to netfilter but my problem is:

when I run patch-o-matic utility to patch netfilter, it works well and
creates ipt_name.o in /usr/src/linux/net/ipv4/netfilter/.

My great trouble is that my patch has a libipt_name.c in
/usr/src/netfilter/userspace/extensions/.

I don't known add it to the makefile to create libipt_name.so (shared
object) in /lib/iptables/.


Could anybody help me,please?

Thanks.


___________________________________________________
Yahoo! Móviles
Personaliza tu móvil con tu logo y melodía favorito 
en http://moviles.yahoo.es
