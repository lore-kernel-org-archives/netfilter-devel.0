From: Thomas Heinz <creatix@hipac.org>
Subject: target_info read only?
Date: Tue, 21 Jan 2003 00:37:35 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E2C883F.7070707@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi

A netfilter target (struct ipt_entry_target) can contain an
arbitrary amount of private data which is delivered to the
target function in case the corresponding rule matches.

Now it would be possible for the target function to modify
the private data although I haven't seen any target that
does this. In contrast to targets this behaviour is quite
normal for matches, especially stateful ones.

Now, I have two questions:

1) Is there any target (kernel and cvs) that already modifies
    its private data (maybe I have overlooked one)?

2) If ! 1) is there any reason for which targets might want
    to write to their private data buffer and if not can
    I assume that netfilter targets must (sort of unwritten law
    like) treat their private data as read only?

Thanks for your answer.


Regards,

Thomas
