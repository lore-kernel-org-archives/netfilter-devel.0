From: Jvalencia <tigrezno@log01.org>
Subject: libipq: a way to use various programs?
Date: Fri, 22 Oct 2004 17:41:52 +0100
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022174152.1424501d.tigrezno@log01.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi again, i'm trying to use 2 libipq programs to handle packets, but it looks like only one catching them.
Is there any way to allow more than one program handle packets, like a chain?

packet -> INPUT chain -> QUEUE target -> program 1 -> program 2 -> INPUT chain next target.

Thanks.
