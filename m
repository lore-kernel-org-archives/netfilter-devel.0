From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] raw table and NOTRACK support
Date: Tue, 22 Nov 2005 16:40:19 +0100
Message-ID: <43833BE3.8060909@tac.ch>
References: <4381A0C3.7020406@tac.ch> <438327D2.5090506@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <438327D2.5090506@tac.ch>
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

> [3]kdb> bt
> Stack traceback for pid 7064
> 0xf5c72000     7064     7011  1    3   R  0xf5c722b0 *rmmod
> EBP        EIP        Function (args)
> 0xf5c73f0c 0xf89a723f [ip_conntrack]get_next_corpse+0xbf (0xf89a7470,
> 0x0, 0xf5c73f20, 0x1fe2, 0xf5c72000)
>                                ip_conntrack .text 0xf89a4060 0xf89a7180
> 0xf89a72d0
> 0xf5c73f30 0xf89a7303
> [ip_conntrack]ip_ct_iterate_cleanup_Rsmp_4ff11842+0x33 (0xf89a7470, 0x0,
> 0x0)
>                                ip_conntrack .text 0xf89a4060 0xf89a72d0
> 0xf89a7370
> 0xf5c73f44 0xf89a74f7 [ip_conntrack]ip_conntrack_cleanup+0x77
> (0xf89a990f, 0xc2a7bd20, 0xc0471e20, 0xf89a4000)
>                                ip_conntrack .text 0xf89a4060 0xf89a7480
> 0xf89a7550
> 0xf5c73f5c 0xf89a479f [ip_conntrack]init_or_cleanup+0x17f (0x0)
>                                ip_conntrack .text 0xf89a4060 0xf89a4620
> 0xf89a4810
> 0xf5c73f68 0xf89a4a22 [ip_conntrack]fini+0x12 (0xf89a4000, 0xfffffff0,
> 0xf5d8b000, 0xf5c73f84, 0xf89a4000)
>                                ip_conntrack .text 0xf89a4060 0xf89a4a10
> 0xf89a4a24
> 0xf5c73f8c 0xc0120641 free_module+0x111 (0xf89a4000, 0x0, 0x1000,
> 0xbfffde18, 0xf5c72000)
>                                kernel .text 0xc0100000 0xc0120530 0xc0120660
> 0xf5c73fbc 0xc011f639 sys_delete_module+0x129 (0xbffffcd9, 0xbfffefd4,
> 0xbfffdf2c, 0x1, 0xbfffdf2c)
>                                kernel .text 0xc0100000 0xc011f510 0xc011f940
>            0xc010774f system_call+0x33
>                                kernel .text 0xc0100000 0xc010771c 0xc0107754
> [3]kdb>

I don't get it. It's looping in:

void
ip_ct_iterate_cleanup(int (*iter)(struct ip_conntrack *i, void *), void
*data)
{
        struct ip_conntrack_tuple_hash *h;
        unsigned int bucket = 0;

        while ((h = get_next_corpse(iter, data, &bucket)) != NULL) {
                /* Time to push up daises... */
                if (del_timer(&h->ctrack->timeout))
                        death_by_timeout((unsigned long)h->ctrack);
                /* ... else the timer will get him soon. */

                ip_conntrack_put(h->ctrack);
        }
}

which is called from:

void ip_conntrack_cleanup(void)
{
        ip_ct_attach = NULL;
        /* This makes sure all current packets have passed through
           netfilter framework.  Roll on, two-stage module
           delete... */
        br_write_lock_bh(BR_NETPROTO_LOCK);
        br_write_unlock_bh(BR_NETPROTO_LOCK);

 i_see_dead_people:
        ip_ct_iterate_cleanup(kill_all, NULL);
        if (atomic_read(&ip_conntrack_count) != 0) {
                schedule();
                goto i_see_dead_people;
        }
        while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
                schedule();

        kmem_cache_destroy(ip_conntrack_cachep);
        vfree(ip_conntrack_hash);
        nf_unregister_sockopt(&so_getorigdst);
}

I don't see where ip_conntrack_untracked.ct_general.use is > 1, ever ...

I'm completely puzzled,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
