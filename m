From: Chuck Ebbert <cebbert@redhat.com>
Subject: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Tue, 20 Feb 2007 20:10:55 -0500
Message-ID: <45DB9C1F.1080605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932305AbXBUBLZ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

I was testing a 2.6.20 kernel and got a soft
lockup on shutdown:

_raw_write_lock+0x5a
nf_ct_iterate_cleanup+0x3e
kill_l3proto+0x0
nf_conntrack_l3proto_unregister+0x85
nf_conntrack_l3proto_ipv4_fini+0x1e
sys_delete_module+0x18a
remove_vma+0x45
do_munmap+0x196
syscall_call+0x7
