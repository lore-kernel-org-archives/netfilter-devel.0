From: Alan Hourihane <alanh@fairlite.demon.co.uk>
Subject: POMNG problems
Date: Tue, 23 Nov 2004 19:23:49 +0000
Message-ID: <20041123192348.GS10113@fairlite.demon.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

I'm using pomng-20040621 and it fails to apply some of the base patches
with kernel 2.4.27, and 2.4.28 has caused another one to fail.

Currently, I have to delete...

init_conntrack-optimize
ipt_helper-invert-fix
nf_reset

for 2.4.27 to compile successfully, and with 2.4.28 I now have to remove

raw

to build a kernel.

Is there a new release of pomng coming soon ?

Alan.
