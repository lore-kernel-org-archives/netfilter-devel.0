From: Patrick McHardy <kaber@trash.net>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Sat, 24 Feb 2007 14:58:00 +0100
Message-ID: <45E04468.7020001@trash.net>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45DCEA47.5080100@redhat.com>
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

Chuck Ebbert wrote:
> Chuck Ebbert wrote:
> 
>>I was testing a 2.6.20 kernel and got a soft
>>lockup on shutdown:
>>
>>_raw_write_lock+0x5a
>>nf_ct_iterate_cleanup+0x3e
>>kill_l3proto+0x0
>>nf_conntrack_l3proto_unregister+0x85
>>nf_conntrack_l3proto_ipv4_fini+0x1e
>>sys_delete_module+0x18a
>>remove_vma+0x45
>>do_munmap+0x196
>>syscall_call+0x7
> 
> 
> Happened three times in a row, trying to remove
> netfilter modules.

Does it happen when you unload only nf_conntrack_ipv4, or do
you need to unload other modules previously? Does it really
lock up?

Please also send your config.
