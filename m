From: anjanish pandey <anjanish@yahoo.com>
Subject: Info on ICMP checksum calculation
Date: Thu, 11 Aug 2005 00:26:32 -0700 (PDT)
Message-ID: <20050811072632.22248.qmail@web32512.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

I am new to this kernel code. 

I want to know, how this skb checksum works. 

I have a driver, which appends the packet, with header
of 24 bytes, when the packet goes out, and deletes 24
bytes, header from the packet, when it comes in. 

What I am interested to know is, do I need to
re-calculate skb->csum, after the 24 bytes has been
removed from the packet.

I have another query, why icmp.c doesn't have any
direct check for ICMP checksum, though it does have
skb checksum verification.

One more query is, which part of the code, in linux,
calculates the checksum for skb and update the
skb->csum, when ethernet packet it recieved at the
interface.

Thank in advance for your help.

Regards,
Anjanish

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
