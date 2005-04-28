From: Amin Azez <azez@ufomechanic.net>
Subject: skb->mac.raw, when is does it point to ethhdr
Date: Thu, 28 Apr 2005 17:29:35 +0100
Message-ID: <d4r2n4$o39$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I've been treating skb->mac.raw as a pointer to ethhdr and stealing mac 
addresses when conntrack's are created.

So the question comes up, how do we tell when skb->mac.raw is pointing 
to an ethernet frame header and when it is pointing to something else?

I found a case even in ethernet only systems where if traffic is sent to 
a non-existant host then some associated skb have skb->mac.raw not NULL 
but also point to something else, or at least something quite bogus, for 
my to copy mac address memcpy was tying to copy sizeof(ethhdr) from 
fbdb1200, or sometimes from such addresses as 003ba300, which indictaes 
sometimes it is not even a valid pointer to anywhere. I got:

Unable to handle kernel paging request at virtual address fbdb1200

So I need to find out how to tell when skb->mac.raw points to a valid 
ethhdr struct.

The clue must be in sk_buff somewhere.

net_device, a likely candidate seems too opaque, with nothing to 
indicate device type, or link layer header struct type.

I guess I could look for skb->mac_len to be the same as ethernet maclen, 
but thats a cheat.

Thats about all I can find.

Any ideas?

Amin
