From: Alexander Nasonov <alnsn-mycop@yandex.ru>
Subject: ASN.1 decoder for h323-conntrack-nat
Date: Thu, 16 Oct 2003 15:25:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8E9C32.1050609@yandex.ru>
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

Hi!
Sorry, I don't have enough time right now to understand how current 
version of h323-conntrack-nat works. Probably, what I'm going to 
announce here is already implemented.
Anyway, here is what I have. I've implemented callback-based decoder of 
ASN.1 PER rules. With a help of this decoder it's possible to analyze 
H323 packet and to call user-defined function when the code came across 
an interesting type. For example, it's easy to jump from fastStart 
element to OpenLogicalChannel or to detect OpenLogicalChannel -> 
reverseLogicalChannelParameters -> mediaChannel -> ipAddress sequence.
Generated code doesn't have dynamic memory allocations and other 
undeterministic stuff. It just easts bits :))) In it's current state the 
code is ugly (due to deadline) and it is C++. If there is an interest, I 
can rewrite it later.
--
Alexander Nasonov
