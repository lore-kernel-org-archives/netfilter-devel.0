From: Georg Chini <georg.chini@triaton-webhosting.com>
Subject: Re: iptables+2.6-test8-bk4 : Still problems
Date: Tue, 28 Oct 2003 21:31:02 +0100
Sender: sparclinux-owner@vger.kernel.org
Message-ID: <3F9ED206.4040806@triaton-webhosting.com>
References: <3F9B8A5D.9010803@triaton-webhosting.com>	<200310261052.25944.rezso@rdsor.ro> <20031026223438.1cf757ce.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Balint Cristian <rezso@rdsor.ro>, sparclinux@vger.kernel.org,
	netfilter-devel@lists.netfilter.org
Return-path: <sparclinux-owner@vger.kernel.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031026223438.1cf757ce.davem@redhat.com>
List-Id: netfilter-devel.vger.kernel.org

David S. Miller wrote:
> It's some bug in the translation code in net/compat.c

Yes it is.
The problem is, that the ipt_entries are not all the same
size. So instead of copying them one by one you have
to copy the whole block. Here is a patch:


--- linux-test/net/compat.c     Tue Oct 28 21:15:36 2003
+++ linux-2.6.0-test9/net/compat.c      Tue Oct 28 20:52:43 2003
@@ -318,11 +318,12 @@
  {
         struct compat_ipt_replace *urepl = (struct compat_ipt_replace *)optval;
         struct ipt_replace *repl_nat;
+       struct ipt_entry *k_ipt_entries;
         char name[IPT_TABLE_MAXNAMELEN];
         u32 origsize, tmp32, num_counters;
         unsigned int repl_nat_size;
         int ret;
-       int i, num_ents;
+       int i;
         compat_uptr_t ucntrs;

         if (get_user(origsize, &urepl->size))
@@ -366,15 +367,14 @@
             __put_user(compat_ptr(ucntrs), &repl_nat->counters))
                 goto out;

-       num_ents = origsize / sizeof(struct ipt_entry);
-
-       for (i = 0; i < num_ents; i++) {
-               struct ipt_entry ent;
+       k_ipt_entries = (struct ipt_entry *)kmalloc(origsize, GFP_KERNEL);
+       if (__copy_from_user(k_ipt_entries, &urepl->entries[0], origsize) ||
+           __copy_to_user(&repl_nat->entries[0], k_ipt_entries, origsize)) {
+               kfree(k_ipt_entries);
+               goto out;
+               }

-               if (__copy_from_user(&ent, &urepl->entries[i], sizeof(ent)) ||
-                   __copy_to_user(&repl_nat->entries[i], &ent, sizeof(ent)))
-                       goto out;
-       }
+       kfree(k_ipt_entries);

         for (i = 0; i < NF_IP_NUMHOOKS; i++) {
                 if (__get_user(tmp32, &urepl->hook_entry[i]) ||

