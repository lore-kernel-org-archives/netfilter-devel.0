From: Ned Ren <nedren@yahoo.com>
Subject: IS THIS A BUG? (ip_conntrack_core.c)
Date: Thu, 16 Oct 2003 18:52:03 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031017015203.4800.qmail@web80510.mail.yahoo.com>
Reply-To: nedren@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,
 
Maybe I'm not seeing deep enough, or maybe this is a
bug? Could someone explain this code to me pls? This
code is in all kernel versions.
 
"ip_conntrack_core.c"
static int early_drop(struct list_head *chain)
{
 ......

 if (del_timer(&h->ctrack->timeout)) {
  death_by_timeout((unsigned long)h->ctrack); <====
  dropped = 1;
 }
 ip_conntrack_put(h->ctrack); <==== ????
 return dropped;
}

At the end of death_by_timeout(), there is already an
ip_conntrack_put(contrack). Is this double freeing
here? Probably this is not causing any problems, but
is this a bug? 

And same thing in ip_ct_selective_cleanup().


Thank you!!

Ned
