From: Roc Bai <buroc83@gmail.com>
Subject: how to use sk_run_filter() in the kernel?
Date: Sun, 30 Jan 2011 15:26:20 +0800
Message-ID: <AANLkTi=cwGj624jicA4C9KrbofvXNwt0a_T33zpSYZAa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40308 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1A3H0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Jan 2011 02:26:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, all:
   I want to use the sk_run_filter() in the bridge module, and if the
skb meet the filter the skb will be forward to a specify port. I do it
like this:

1) use the libpcap create pcap, compile rule, and attach the filter

int compile_rule(const char *expr)
{
        struct bpf_program fp;
        pcap_t *pcap;
        static char errbuf[1024];

        pcap = pcap_open_live("eth0", 65535, 1, 1000, errbuf);
        //pcap = pcap_open_dead(DLT_EN10MB, 2600);
        if(NULL == pcap) {
                fprintf(stdout, "create pcap failure! %s\n", errbuf);
                return -1;
        }

        if (0 != pcap_compile(pcap, &fp, expr, 0, 0xFFFFFF00)) {
                fprintf(stdout, "compile pcap failure!\n");
                return -1;
        }

        if (0 != pcap_setfilter(pcap, &fp)) {
                fprintf(stdout, "setfilter failure!\n");
                return -1;
        }

        return 0;
}


2) change the sk_attach_filter() routine which will call my_sk_attach_filter()

struct bnf_ether
{
        struct sk_filter *filter;
        struct net_bridge_port *dst;
};

struct bnf_ether *ether;

unsigned int fsize = sizeof(struct sock_filter) * fprog->len;
fp = kmalloc(fsize + sizeof(*fp), GFP_KERNEL);
copy_from_user(fp->insns, fprog->filter, fsize);
atomic_set(&fp->refcnt, 1);
fp->len = fprog->len;
....
rcu_assign_pointer(ether->filter, fp);
ether->port = dst_port;
....

3) When the packet arrivied, calling my_get_port_dst(struct sk_buff
skb) to search  target port.

filter = rcu_dereference_bh(ether->filter);
res = sk_run_filter(skb, filter->insns, filter->len);

if (res) {
    return ether-> port;
}


But i find sk_run_filter returns 0 all the time. I think something
wrong in my code. How i fix it? And i find the  pcap_setfilter() will
call sk_attach_filter() twice, why?

Best Regards

Bai Shuwei

-- 
------------------------

Thinking before action, but you are wasting time if you don't do action.
