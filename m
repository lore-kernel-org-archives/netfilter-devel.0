From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] peer_pid checking in ip_queue
Date: Tue, 23 Mar 2004 19:10:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40607DAC.2090404@eurodev.net>
References: <40601AE4.5070206@eurodev.net> <406072ED.8060304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
 netfilter-devel@lists.netfilter.org,
 Harald Welte <laforge@netfilter.org>
In-Reply-To: <406072ED.8060304@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Patrick McHardy wrote:

> peer_pid is protected by queue_lock, you move it out of the locked
> section. This leads to a small race which can cause message loss. Not 
> sure if it's bad though as netlink is unreliable itself.

yes it's true, well if i'm not wrong, this small race could happen for 
first packets which are going to be
enqueued, is it?.

For example, two packets arrive almost at the same time, ip_queue 
allocates space for both new entries to be enqueued, first packet is not 
enqueued because peer_pid is 0 but, in that moment, the user space 
program binds to ip_queue's netlink sockets, but entry for second packet 
is already created and peer_pid is not 0 anymore, so this packet is 
enqueue. With my patch, both packets will be lost, with current 
implementation one is lost and the other one is enqueued.

By other hand, I think that if user programs hungs or dies, we stress 
the kernel allocating
and releasing memory all the time. So, my question is, is really a 
problem losing these packets?

thanks for the feedback,
Pablo
