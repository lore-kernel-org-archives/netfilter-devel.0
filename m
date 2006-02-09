From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Re: Understanding Netfilter and IPSec Transport Mode over NAT
Date: Thu, 09 Feb 2006 13:44:18 -0500
Message-ID: <43EB8D82.1090801@certicom.com>
References: <43E8F7B7.6020106@certicom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <43E8F7B7.6020106@certicom.com>
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


Chinh Nguyen wrote:
> Hi,
> The first question is more academic. How does a per-socket bypass policy equals
> "accept transport mode ESP"?
> 
> The second question is more pragmatic. Why doesn't this work for TCP? With
> encrypted TCP traffic, the skb->sp is NULL, therefore esp_post_input is not
> called. Why? However, the decrypted TCP packet itself seems to be sent up the
> stack since netstat reveals that bad TCP segments are being received.

I discovered that the "bug" is in the function tcp_v4_rcv for kernel 2.6.16-rc1.

After the ESP packet is decapped and decrypted in xfrm4_rcv_encap_finish, the
unencrypted packet is pushed back through ip_local_deliver. For a UDP packet, it
goes (back) to function udp_queue_rcv_skb. The first thing this function does is
called xfrm4_policy_check. As noted previously, in xfrm4_policy_check, if the
skb->sp != NULL, the esp_post_input function is called. The post input function
sets skb->ip_summed to CHECKSUM_UNNECESSASRY if we are in transport mode.
Therefore, further down in udp_queue_rcv_skb, we skip the checksum check and the
packet is passed up the stack.

However, for a decrypted TCP packet, the packet goes to tcp_v4_rcv. This
function does the checksum check right away if skb->ip_summed !=
CHECKSUM_UNNECESSARY while xfrm4_policy_check is called a little later in the
function. Therefore, the esp post input has not yet set the ip_summed to
unnecessary. The decrypted packet fails the checksum and is discarded.

To confirm this, I added another call to xfrm4_policy_check before the checksum
check in tcp_v4_rcv (to call esp post input). Once patched, my systems were able
to initiate TCP connections using Transport Mode/NAT.

    printk(KERN_INFO "tcp_v4_rcv: tcp patch\n");
    if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
        goto discard_it;
    nf_reset(skb);

    printk(KERN_INFO "tcp_v4_rcv: skb = %08x, skb->ip_summed = %d\n", skb,
skb->ip_summed);
    /* An explanation is required here, I think.
     * Packet length and doff are validated by header prediction,
     * provided case of th->doff==0 is eliminated.
     * So, we defer the checks. */
    if ((skb->ip_summed != CHECKSUM_UNNECESSARY &&
         tcp_v4_checksum_init(skb)))
        goto bad_packet;

    printk(KERN_INFO "tcp_v4_rcv: sum ok\n");


I don't consider this a real patch because it's inefficient to have 2 calls to
xfrm4_policy_check in tcp_v4_rcv.

Is this the right list to bring up this issue or should I go to some other list
(e.g., linux-kernel, etc)?

Regards,

Chinh
