From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: iptables_target and unknown size data.
Date: Wed, 26 Nov 2003 12:05:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FC47AEA.5090104@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
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

Hei!

I am writing an iptables extension. It's a new target. My problem is 
that I need to use a linked list whose size is unknown when registering 
the target. As I am not very familiar with the alignment problems, I am 
wondering if it can cause any trouble?

To be a bit more concrete, is the following ok?

struct ipt_sd_host
{
    struct in_addr    address;
    int                port;            
    struct ipt_sd_host    *next_host;
};

struct ip_new_targ_data
{
    struct ipt_sd_host   *host_list;
    int                            min_port;
    int                            max_port;
};

static
struct iptables_target my_new_target
= { NULL,
    "NEWTARG",
    IPTABLES_VERSION,
    IPT_ALIGN(sizeof(struct ip_new_targ_data)),
    IPT_ALIGN(sizeof(struct ip_new_targ_data)),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};


                 Emmanuel
