From: "=?ISO-8859-1?Q?Kerry_=D3_Cuanach=E1in?="
	<kerry.ocuanachain@googlemail.com>
Subject: Notification of new/destroyed connection
Date: Thu, 12 Jul 2007 09:00:37 +0100
Message-ID: <f258d7a40707120100n14470075hd78309e5173f61b0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Following on from the discussion on CT lifecycle events, if one takes
a scenario whereby a newly created connection is subsequently
NF_DROP'd by a filter rule, is it exclusively a timer/timeout which
results in that same connection being destroyed?
Is there any event driven mechanism to inform conntrack that the
packet has been filtered?
Similarly, is there an way to identify the reason for IPCT_DESTROY
from the event raised?


Kind Regards

Kerry
