From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Understanding Netfilter and IPSec Transport Mode over NAT
Date: Tue, 07 Feb 2006 14:40:39 -0500
Message-ID: <43E8F7B7.6020106@certicom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Hi,

I realize that this is a devel mailing-list. My apologies.

I am having problem with Racoon and Transport Mode over NAT (for TCP traffic)
for kernel 2.6.16-rc1. I'm trying to understand how Netfilter works and I'm stumped.

I've embedded some printk statements but I'll probably have to do some live
debugging unless someone can point out what's going on.

When I modify Racoon to NOT push an sadb_x_policy (in/out bypass) for the
IKE/IKE-NAT ports via setsockopt, UDP-encap ESP carrying UDP data is rejected in
__xfrm_policy_check.

The standard Racoon which pushes an in/out bypass per-socket policy accepts
encrypted UDP traffic. After decap, the associated skb has a security path. As
such, the post_input function (ie, esp4_post_input) sets the skb->ipsummed to
ignore checksum. The result is that UDP traffic is accepted as shown below:

Feb  7 13:29:30 localhost kernel: [17179776.692000] esp_input begin
Feb  7 13:29:30 localhost kernel: [17179776.692000] esp_input encap block
Feb  7 13:29:30 localhost kernel: [17179776.692000] esp_input decap_type block
Feb  7 13:29:30 localhost kernel: [17179776.692000] esp_input end
Feb  7 13:29:30 localhost kernel: [17179776.692000] xfrm4_rcv_encap: skb->sp !=
NULL = 1
Feb  7 13:29:30 localhost kernel: [17179776.692000] xfrm_pol_check: skb->sp !=
NULL? = 1
Feb  7 13:29:30 localhost kernel: [17179776.692000] esp_post_input begin
Feb  7 13:29:30 localhost kernel: [17179776.692000] props.mode = 0, ip_summed =
2 (CHECKSUM_UNNECESSARY)
Feb  7 13:29:30 localhost kernel: [17179776.692000] xfrm_pol_check: pol != NULL? = 1
Feb  7 13:29:30 localhost kernel: [17179776.692000] xfrm_pol_check: accept

The first question is more academic. How does a per-socket bypass policy equals
"accept transport mode ESP"?

The second question is more pragmatic. Why doesn't this work for TCP? With
encrypted TCP traffic, the skb->sp is NULL, therefore esp_post_input is not
called. Why? However, the decrypted TCP packet itself seems to be sent up the
stack since netstat reveals that bad TCP segments are being received.

Feb  7 13:37:08 localhost kernel: [17180234.228000] esp_input begin
Feb  7 13:37:08 localhost kernel: [17180234.228000] esp_input encap block
Feb  7 13:37:08 localhost kernel: [17180234.228000] esp_input decap_type block
Feb  7 13:37:08 localhost kernel: [17180234.228000] esp_input end
Feb  7 13:37:11 localhost kernel: [17180234.228000] xfrm4_rcv_encap: skb->sp !=
NULL = 1
Feb  7 13:37:11 localhost kernel: [17180234.228000] xfrm_pol_check: skb->sp !=
NULL? = 0
Feb  7 13:37:11 localhost kernel: [17180237.256000] xfrm_pol_check: pol != NULL? = 1
Feb  7 13:37:11 localhost kernel: [17180237.256000] xfrm_pol_check: accept

Chinh
