From: Roland Wehage <RWE@zurich.ibm.com>
Subject: Netfilter and Kernel Threads
Date: Wed, 26 Jan 2005 13:24:52 +0100
Message-ID: <OFDADA6776.7D6B0627-ONC1256F95.0043FD45-C1256F95.00443200@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello,

I hope you can help me, you would do me a great favour...

My question is about Linux Netfilter (I am using Kernel 2.6.10):

Background:
I am writing a Netfilter module and a driver for a hardware packet
classifier. So the filtiring should take place for every packet that passes
one of the following Netfilterhooks:
-NF_IP_FORWARD
-NF_IP_LOCAL_IN
-NF_IP_LOCAL_OUT
When a packet is send to the classifier (by using a PCI-Bus), the module
can only expect a certain number returned (for example: 0 = Accept packet,
1 = Drop...). So I am not getting back any packet ID or something like
this.

Because it can happen, that Netfilter calls this module faster than the
classifier is able to do the filtering, I thought of creating a kernel
thread for each packet:

for example:

unsigned int example_hook(unsigned int hooknum, struct sk_buff **skb, ...)
{
      ...
      thread_id = kernel_thread(thread_code, NULL, CLONE_KERNEL);
      ...
}

After forwarding the packet to the Classifier, the thread is set asleep and
waits for being woken up. After the PCI-Bus returned an interrupt the
thread is woken up.
My problem is that I cannot create threads in this architecture.

My test code is something like this:

...

static wait_que_head_t wq;
static int thread_id = 0;
static DECLARE_COMPLETION(on_exit);
statir int first = 1;

...

static int thread_code(void *data)
{
      daemonize("ThisThread");
      allow_signal(SIGTERM);
      thread_id = 0;
      complete_and_exit(&on_exit, 0);
}

unsigned int example_hook(unsigned int hooknum, struct sk_buff **skb, ...)
{
      if(first)//only to guarantee that only the first call will create a
thread, to show that the system crashes
      //whenever kernel_thread() is called
      {
            first = 0;
            thread_id = kernel_thread(thread_code, NULL, CLONE_KERNEL);
            if(thread_id)
                  kill_proc(thread_id, SIGTERM, 1);
            wait_for_completion(&on_exit);
      }
      return NF_ACCEPT;
}

static struct nf_hook_ops example_ops =
{
      .hook = example_hook,
      .pf = PF_INET,
      .hooknum = NF_IP_LOCAL_IN,
      .priority = -1,
};

static int __init mod_init(void)
{
      init_waitqueue_head(&wq);
      if(nf_register_hook(&example_ops) < 0)
            return 1;
      return 0;
}

static void __exit mod_exit(void)
{
      nf_unregister_hook(&example_ops);
}

My problem is, that the system crashes when I load this module and I just
do not know why.

The following construction works, but is not what I need, I cannot see the
main difference, why this works and the construction above not:

...

static wait_que_head_t wq;
static int thread_id = 0;
static DECLARE_COMPLETION(on_exit);
...

static int thread_code(void *data)
{
      daemonize("ThisThread");
      allow_signal(SIGTERM);
      thread_id = 0;
      complete_and_exit(&on_exit, 0);
}

unsigned int example_hook(unsigned int hooknum, struct sk_buff **skb, ...)
{
      return NF_ACCEPT;
}

static struct nf_hook_ops example_ops =
{
      .hook = example_hook,
      .pf = PF_INET,
      .hooknum = NF_IP_LOCAL_IN,
      .priority = -1,
};

static int __init mod_init(void)
{
      init_waitqueue_head(&wq);
      thread_id = kernel_thread(thread_code, NULL, CLONE_KERNEL);
      if(thread_id)
            kill_proc(thread_id, SIGTERM, 1);
      wait_for_completion(&on_exit);
      if(nf_register_hook(&example_ops) < 0)
            return 1;
      return 0;
}

static void __exit mod_exit(void)
{
      nf_unregister_hook(&example_ops);
}

You would do me a grait favour, if you would help me. Thanks a lot!

With regards,

Roland Wehage.
