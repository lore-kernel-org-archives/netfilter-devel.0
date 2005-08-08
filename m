From: Aleksandar Milivojevic <alex@milivojevic.org>
Subject: ipsec in transport mode is not handled correctly
Date: Mon, 08 Aug 2005 10:34:59 -0500
Message-ID: <20050808103459.e1sm3gpj4wgs4coc@www.milivojevic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-disposition: inline
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

I've noticed that on kernel-2.6.9-11.EL IPSec packets go through INPUT chain of
filter table only once if I use IPSec in transport mode.  They go there only
encrypted (ESP packet), but there's no second pass with decrytped packet.

If I change IPSec configuration to use tunnel mode, everything works as
expected.

I've made a much more detailed description at:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=165359

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
