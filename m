From: Olivier <olivier@lx.student.wau.nl>
Subject: status  on extremely slow traffic with linux-2.6.0-test9 ?
Date: Fri, 7 Nov 2003 08:33:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107083301.22522f4a.olivier@lx.student.wau.nl>
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

I switched to linux-2.6.0-test9 and I noticed an incredible slowdown in
outbound traffic (10 minutes to upload 5mb over a 10Mbit line). I saw in
the archives of this list that some more people reported this.

I've loaded the following modules:
ipt_multiport           2176  8
ipt_state               2048  2
ip_conntrack           31792  1 ipt_state
iptable_filter          2944  1
ip_tables              18048  3 ipt_multiport,ipt_state,iptable_filter
e1000                  80772  0

it seems I have the same problem  as reported by other people. But I was
wondering if the problem is fixed, and if there is a patch available for
testing?

thanks for the excellent work,
	Olivier
