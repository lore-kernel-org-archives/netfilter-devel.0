From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_ACCOUNT accounting target released
Date: Wed, 28 Apr 2004 00:16:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408EDBCC.8050502@trash.net>
References: <200404131731.02001.thomas.jarosch@intra2net.com> <200404261336.08119.thomas.jarosch@intra2net.com> <408DB05E.6010706@trash.net> <200404271012.29136.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
In-Reply-To: <200404271012.29136.thomas.jarosch@intra2net.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thomas Jarosch wrote:
> Thanks for your reply. I'll fix the coding style
> and will post a new patch soon.

Thanks.

> Premature optimization is the root of all evil ;-)
> Is see what I can do, but IMHO this will increase
> the complexity of the ipt_account_handle_get_data() function.
> 
>>Why does it need a PAGE_SIZE >= 4096 ?
> 
> The internal data layout for a 8 bit network (256 hosts/CLASS C) is
> designed to fit into a kernel zero page. As the code is designed for constant
> (meaning every second/every 10 seconds) readout of the data,
> kmalloc would be too expensive as snapshots of the data are created.

Are you sure kmalloc is too slow for once a second allocations ?
Or could this be a premature optimization ? ;) Anyway, PAGE_SIZE
is a constant so you can check at compile time:

#if (PAGE_SIZE < 4096)
#error "..."
#endif

One more thing:

             if (copy_to_user(...))
             {
                 printk("ACCOUNT: ...");

Just return -EFAULT.

             if (handle.handle_nr >= ACCOUNT_MAX_HANDLES)
             {
                 printk("ACCOUNT: ...);
-EINVAL.


Regards
Patrick
