From: "Richard" <richard@o-matrix.org>
Subject: target for modifying conntrack timeout value
Date: Tue, 30 Nov 2004 14:46:50 -1000
Message-ID: <EINSTEINorwBpP6m6PU0000637c@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,

I wonder if there is a target to modify the conntrack timeout value. For
example, an established udp connection has a 180 seconds timeout value. It
is sufficient for most applications. However some need to have a higher
value. What I'd like is the ability to set the timeout value in the
conntrack.

Is there such a target already? If not, is it feasible?

Thanks,
Richard
