From: "Thomas T. Soares" <ttsoares@brturbo.com>
Subject: Dependence issue on today cvs
Date: 04 Jun 2002 00:33:46 -0300
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023161627.8328.4.camel@dentro>
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

Hi all packets hackers...

This is just to inform that the today CVS of netfilter is giving this
  to me:

make patch-o-matic
Making dependencies: please wait...
Something wrong... deleting dependencies.
make: *** [/coisas/linux/include/linux/netfilter_ipv4/ipt_dcsp.h] Error1

This is over 2.4.18 and 2.4.19-pre10.

The iptables-1.2.6a is working fine with this same kernel sources...

Thank you.

-- 
| Thomas Tschoepke Soares                   |     //   En brujas no
|               ttsoares AT brturbo DOT com |(~~~//'~)    acreo...
|--UIN:961141-------------------------------| \     /  pero que las hay,
| The fact is a secondary aspect of reality |  `\_/'          las hay !
